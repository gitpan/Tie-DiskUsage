package Tie::DiskUsage;

$VERSION = '0.1';
@ISA = qw(Tie::StdHash);

use strict;
use vars qw($DU_BIN);
use Carp 'croak';
use Tie::Hash;


$DU_BIN = '/usr/bin/du';


sub TIEHASH { 
    my $pkg = shift;
     
    return bless( &_tie, $pkg );
}

sub UNTIE {}

sub _tie {
    _locate_du();
    
    return &_parse_usage;
}

sub _locate_du {
    if (not (-e $DU_BIN && -f $DU_BIN) && $] >= 5.008) { 
        require File::Which;
	my $du_which = File::Which::which('du');
	
	$du_which 
	  ? $DU_BIN = $du_which 
	  : croak "Couldn't locate $DU_BIN: $!";
    }
}

sub _parse_usage {
    my $path = shift || '.';
    
    my %usage;
    
    local *PIPE;
    open PIPE, "$DU_BIN @_ $path |" or exit 1;
    {
         local ($/, $_); 
	 $/ = '';
	  
	 $_ = <PIPE>;
         %usage = (reverse split);
    }
    close PIPE 
      or croak "Couldn't drop pipe to $DU_BIN: $!";
      
    return \%usage;
} 

1;
__END__

=head1 NAME

Tie::DiskUsage - Tie disk-usage to a hash

=head1 SYNOPSIS

 require Tie::DiskUsage;

 tie %usage, 'Tie::DiskUsage', '/var', '-h';
 print $usage{'/var/log'};
 untie %usage;

=head1 DESCRIPTION

Tie::DiskUsage ties the disk-usage, which is gathered
from the output of C<du>, to a hash. If the path to perform 
the du-command on is being omitted, the current working 
directory will be examined; optional arguments to C<du> may be 
passed subsequently.

By default, the location of the du-command is to be
assumed in F</usr/bin/du>; if C<du> cannot be found to exist
there, C<File::Which> will attempt to gather its former location.

The default path to C<du> may be overriden by setting 
$Tie::DiskUsage::$DU_BIN. 

=head1 SEE ALSO

L<perlfunc/tie>, du(1)

=cut
