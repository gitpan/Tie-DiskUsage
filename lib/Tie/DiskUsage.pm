package Tie::DiskUsage;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.04';

our @ISA = qw(Tie::StdHash);
use Carp 'croak';
use Tie::Hash;

our $DU_BIN = '/usr/bin/du';

sub TIEHASH {
    my $class = shift;
    return bless \%{&_parse_usage}, $class;
}

sub _parse_usage {
    my $path = shift || '.';
    if ((!-e $DU_BIN || !-f $DU_BIN) && $] >= 5.008) { 
        require File::Which;
	$DU_BIN = File::Which::which('du');
    }
    open PIPE, "$DU_BIN @_ $path & |" or exit 1;       
    my %usage;
    for (<PIPE>) {
        chomp;
        my($size, $item) = split;
	$usage{$item} = $size;
    }
    close PIPE 
      or croak "Couldn't close pipe to $DU_BIN: $!";
    return \%usage;
} 

1;
__END__

=head1 NAME

Tie::DiskUsage - tie disk-usage to an hash.

=head1 SYNOPSIS

 require Tie::DiskUsage;

 tie %usage, 'Tie::DiskUsage', '/var', '-h';
 print $usage{'/var/log'};
 untie %usage;

=head1 DESCRIPTION

Tie::DiskUsage ties the disk-usage, which is gathered
from the output of C<du>, to an hash. If the path to perform 
the du-command on is being omitted, the current working 
directory will be examined; optional arguments to C<du> may be 
passed subsequently.

By default the location of the du-command is to be
assumed in F</usr/bin/du>; if C<du> cannot be found to exist
there, C<File::Which> will attempt to gather its former location.

=head1 SEE ALSO

L<perlfunc/tie>, du(1).

=cut
