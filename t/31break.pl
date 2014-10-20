#!perl

# COPYRIGHT AND LICENCE
#
# Copyright (C) 2014 Joshua ben Jore.
#
# This program is distributed WITHOUT ANY WARRANTY, including but not
# limited to the implied warranties of merchantability or fitness for
# a particular purpose.
#
# The program is free software.  You may distribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (either version 2 or any later version)
# and the Perl Artistic License as published by O’Reilly Media, Inc.
# Please open the files named gpl-2.0.txt and Artistic for a copy of
# these licenses.

use strict;
use warnings;
use Getopt::Long qw( GetOptions );
use vars         qw( $Caught $Value );
use lib          qw( ./t );

BEGIN {

    require 'reset_perms.pl';

=head1 DESCRIPTION

This test attempts to run the perl5db debugger, break on a line, then
tests that the break occurred where expected. This tests both that
%{"_<30break.pl"} with L magic and @{"_<30break.pl"} with dual-var
strings has been created.

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

    $ENV{PERLDB_OPTS} = 'noTTY';

    # Option parsing.
    my $import      = 1;
    my @import      = ();
    my $loadPerl5Db = 0;
    GetOptions(
        help         => sub { exec {'perldoc'} 'perldoc', $0 },
        noimport     => sub { $import = 0 },
        'import=s'   => \@import,
        load_perl5db => \ $loadPerl5Db,
    )
      or exec {'perldoc'} 'perldoc', $0;

    # Promote some options into constants.
    require constant;
    constant->import( LoadPerl5Db => !! $loadPerl5Db );

    # The test is whether the debugger runs and is controlled by my
    # test commands here.
    {
	no warnings 'once';
	@DB::typeahead = (
	    'l 1-200',
	    'b sub_d',
	    'c',
	    '$main::Caught = $main::Value',
	    'c',
	    'q'
	    );
    }

    # All our output will go to *OUT. If this program was given a
    # parameter, we accept it as file that we should write our output too.
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
        no warnings 'once';
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
    require Enbugger;
    if ( $import ) {
	Enbugger->import( @import );
    }
}

sub sub_a { $main::Value = 1 }
sub sub_b { $main::Value = 2 }
sub sub_c { $main::Value = 3 }
sub sub_d { $main::Value = 4 }
sub sub_e { $main::Value = 5 }
sub sub_f { $main::Value = 6 }
sub sub_g { $main::Value = 7 }

# Commands executed here:
# > l 1-200
# > b sub_d
# > c
Enbugger->stop;

sub_a();
sub_b();
sub_c();
sub_d(); # Break before invoking.
sub_e();
sub_f();
sub_g();

$Caught = 'undef' if ! defined $Caught;
print "\$Caught = $main::Caught.\n";

# Commands executed here:
# > q
