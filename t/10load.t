#!perl
use strict;
use warnings;
use Test::More tests => 1;

=head1 NAME

10load.t - Tests that the module can be loaded.

=cut

$ENV{PERLDB_OPTS} = 'NonStop=1';
require Enbugger;
Enbugger->import;
ok( 'Loaded Enbugger' );

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:
