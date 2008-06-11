#!perl

use strict;
use warnings;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME          => 'Enbugger',
    VERSION_FROM  => 'lib/Enbugger.pm',
    ABSTRACT_FROM => 'lib/Enbugger.pod',
    AUTHOR        => 'WhitePages.com, Inc <whitepage@cpan.org>',
    LICENSE       => 'perl',
    PREREQ_PM     => {
		      'Test::More' => 0,
		      'B::Utils' => 0,
		     },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Enbugger-Restarts-*' },
);

## Local Variables:
## mode: cperl
## mode: auto-fill
## cperl-indent-level: 4
## End:
