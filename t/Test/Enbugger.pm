package Test::Enbugger;
use strict;
use warnings;

use File::Temp   ();
use Exporter     ();
use Data::Dumper qw( Dumper );
use vars         qw( @EXPORT @EXPORT_OK %EXPORT_TAGS );
use Test::More;

BEGIN {
    *import = \ &Exporter::import;
    @EXPORT_OK = qw( read_file run run_with_tmp );
    $EXPORT_TAGS{all} = [ @EXPORT, @EXPORT_OK ];
}

sub run_with_tmp {
    # I expect to get my output in this file.
    my $tmp_fh = File::Temp->new( UNLINK => 1 );
    my $tmp_nm = $tmp_fh->filename;

    run( @_, $tmp_nm );

    # Get and test the output.
    seek $tmp_fh, 0, 0
      or die "Can't seek $tmp_nm to the beginning: $!";
    my $test_output;
    {
	local $/;
	$test_output = <$tmp_fh>;
    }
    
    close $tmp_fh
      or die "Can't close $tmp_nm: $!";
    
    return $test_output;
}

sub run {
    my @args = @_;
    
    # Some environments require special care.
    if ( $^O eq 'MSWin32' ) {
	# system() does a join( ' ', ... ) first here. I must quote
	# everything for the C RTL that's going to see this.
	#
	# I'm writing this without having a Windows machine around to test
	# on
	for my $arg ( @args ) {
	    $arg =~ s/"/""/g;
	    $arg = qq("$arg");
	}
    }
    else {
	# ...
	
	# Add new OS/environment fiddling here.
    }
    
    # Run the test program.
    system { $args[0] } @args;
    if ( $? ) {
	my $core   = $? & 128;
	my $signal = $? & 127;
	my $exit   = $? >> 8;
	die "Failed to run @args: "
	  . join ' ',
	    ( $core ? 'core dumped' : () ),
	      ( $signal ? "signal: $signal" : () ),
		( $exit ? "exit: $exit" : () );
    }
}

sub read_file {
  my $file = shift @_;
  local $/;
  open my $fh, '<', $file
    or die "Can't open $file for reading: $!";
  return scalar readline $fh;
}

() = -.0


## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:
