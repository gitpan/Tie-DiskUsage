#!/usr/bin/perl

use strict;
use warnings;

use Tie::DiskUsage;

my $path = '/var';
my $log  = "$path/log";

tie my %usage, 'Tie::DiskUsage', $path, '-h';
print "$log: $usage{$log}\n";
untie %usage;
