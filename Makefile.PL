use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Tie::DiskUsage',
    VERSION_FROM => 'lib/Tie/DiskUsage.pm',
    PREREQ_PM    => { Tie::Hash => 0 },
    ($] >= 5.005 
      ? (ABSTRACT_FROM => 'lib/Tie/DiskUsage.pm') : ()
    ),
);
