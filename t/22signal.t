#!perl
use strict;
use warnings;
use Test::More tests => 1;
use Config '%Config';

my @SignalNames = split ' ', $Config{sig_name};
my %SignalNames =
   map {
       $SignalNames[$_] => $_;
   }
   0 .. $#SignalNames;

=head1 DESCRIPTION

This is a basic test that OnError traps a USR1 signal

=cut





BEGIN {
    {
	no warnings 'once';
	@DB::typeahead = (q(main::is( "$@", 'USR1')),'q');
    }
}
use Enbugger::OnError 'USR1';

kill $SignalNames{USR1}, $$;





=begin emacs

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:

=end emacs
