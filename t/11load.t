#!perl
use strict;
use warnings;
use Test::More tests => 12;
use lib 't';
use Test::Enbugger 'run_with_tmp';

=head1 NAME

11load.t - Tests that the module can be loaded and breakpoints
triggered

=over

=cut


my @options = (
	       [ $^X, '-Mblib',       't/11load.pl',                                                       ],
	       [ $^X, '-Mblib',       't/11load.pl',                                          '--noimport' ],
	       [ $^X, '-Mblib',       't/11load.pl',                        '--load_perl5db',              ],
	       [ $^X, '-Mblib',       't/11load.pl',                        '--load_perl5db', '--noimport' ],
	       [ $^X, '-Mblib',       't/11load.pl', '--import', 'perl5db',                                ],
	       [ $^X, '-Mblib',       't/11load.pl', '--import', 'perl5db', '--load_perl5db',              ],
	       [ $^X, '-Mblib', '-d', 't/11load.pl',                                                       ],
	       [ $^X, '-Mblib', '-d', 't/11load.pl',                                          '--noimport' ],
	       [ $^X, '-Mblib', '-d', 't/11load.pl',                        '--load_perl5db',              ],
	       [ $^X, '-Mblib', '-d', 't/11load.pl',                        '--load_perl5db', '--noimport' ],
	       [ $^X, '-Mblib', '-d', 't/11load.pl', '--import', 'perl5db',                                ],
	       [ $^X, '-Mblib', '-d', 't/11load.pl', '--import', 'perl5db', '--load_perl5db',              ],
	      );


for my $args ( @options ) {
    my $test_output = run_with_tmp( @$args );
    like( $test_output, qr/^\$ok = 1\.$/m);
}

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:
