use ExtUtils::MakeMaker;
WriteMakefile(
    DISTNAME     => 'Tie-DiskUsage',
    NAME         => 'Tie::DiskUsage',
    VERSION_FROM => 'lib/Tie/DiskUsage.pm',
    PREREQ_PM    => { Tie::Hash => 0 },
    'dist'       => { COMPRESS => 'gzip', SUFFIX => 'gz' },
    ($] >= 5.005 ? 
       (ABSTRACT_FROM => 'lib/Tie/DiskUsage.pm',
        AUTHOR        => 'Steven Schubiger') : ()),
);
