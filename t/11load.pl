#!perl
use strict;
use warnings;
use Getopt::Long qw( GetOptions );
use vars         qw( $Ok );

BEGIN {

=head1 DESCRIPTION

This test attempts to run the perl5db debugger, gives it some
commands, then tests that the commands occurred. In general the idea
is that depending on how the Enbugger.xs code is modifying COP nodes,
it could have either removed instrumentation from code that should be
instrumented or done the reverse and instrumented the debugger itself.

The output of this program can be read by another program and used in
a test.

=head1 OPTIONS

=over

=item --noimport

Enbugger will be loaded without calling C<< ->import >>.

=item --import ELT

Adds an item to the C<< ->import >> argument list.

=item --help

Runs perldoc on this program.

=item --load_perl5db

After loading Enbugger, C<< Enbugger->load_perl5db >> will also be called.

=back

=cut


    # Option parsing.
    my $import      = 1;
    my @import      = ();
    my $loadPerl5Db = 0;
    my $onError     = 0;
    GetOptions(
	       help         => sub { exec {'perldoc'} 'perldoc', $0 },
	       noimport     => sub { $import = 0 },
	       'import=s'   => \@import,
	       load_perl5db => \ $loadPerl5Db,
	       onerror      => \ $onError,
	      )
      or exec {'perldoc'} 'perldoc', $0;

    # Promote some options into constants.
    require constant;
    constant->import( LoadPerl5Db => !! $loadPerl5Db );


    # The test is whether the debugger runs and is controlled by my
    # test commands here.
    {
	no warnings 'once';
	push @DB::typeahead, '$main::Ok = 1', 'c', 'q';
    }


    # All our output will go to *OUT. If this program was given a
    # paramter, we accept it as file that we should write our output too.
    {
	my ( $file ) = shift @ARGV;
	if ( defined $file ) {
	    open OUT, '>', $file
	      or die "Can't open $file for writing: $!";
	}
	else {
	    *OUT = *STDOUT;
	}

	# OUTPUT is HOT.
	select *OUT;
	$| = 1;

	# Things written to STDERR should also go to our single *OUT.
	*STDERR = $DB::OUT = $DB::LINEINFO = *OUT;
    }


    # Look to see if the debugger is on. Before I go and load
    # Enbugger, I figure I can at least count on being able to examine
    # $^P to see if we were started with the -d debugger flag.
    constant->import( UnderTheDebugger => !! $^P );



    # Load Enbugger and completely knacker our process. This little
    # snippet used to just be a static `use Enbugger;' but I moved it
    # up here when it became obvious that I wanted to optionally avoid
    # importing anything.
    if ( $onError ) {
	require Enbugger::OnError;
	Enbugger::OnError->import;
    }
    else {
	require Enbugger;
	if ( $import ) {
	    Enbugger->import( @import );
	}
    }

    # Now dropping into normal run-time.
}


# Load the perl5db debugger if the user asked for us to do it
# manually. Normally the ->stop method call will also do this for us.
if ( LoadPerl5Db ) {
    Enbugger->load_perl5db;
}


# Trigger a breakpoint.
#
# At this point, I already supplied some commands to the debugger so
# it should go set our $ok variable and then continue on
# automatically.
Enbugger->stop unless $Ok;


# Check that the debugger was stopped and it processed the commands
# requested of it.
$Ok = 'undef' if not defined $Ok;
print "\$ok = $Ok.\n";

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:
