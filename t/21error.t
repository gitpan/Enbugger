#!perl
use strict;
use warnings;
use Test::More tests => 2;

=head1 DESCRIPTION

This is a basic test that OnError ignores an eval wrapped die().

=cut




use vars qw( $Caught );
BEGIN {
    {
	no warnings 'once';
	@DB::typeahead = ('$main::Caught = 1','c');
    }
}
use Enbugger::OnError;

my $ok = eval {
     die "An exception.\n";
     return 1;
};
isnt( $ok, 'Eval died' );
isnt( $main::Caught, q(Didn't trigger the debugger for the exception) );



=begin emacs

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:

=end emacs
