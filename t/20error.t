#!perl
use strict;
use warnings;
use Test::More tests => 1;

=head1 DESCRIPTION

This is a basic test that OnError traps a bare die() successfully.

=cut





BEGIN {
    {
	no warnings 'once';
	@DB::typeahead = (q(main::is( "$@", "An exception.\n")),'q');
    }
}
use Enbugger::OnError;

die "An exception.\n";





=begin emacs

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:

=end emacs
