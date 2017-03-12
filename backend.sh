#!/usr/bin/perl
use FindBin qw($Bin);

my $path=$Bin;

while(1)
{
$start = time();
system("perl $path/backend.pl");
$end = time();
sleep (30-($end-$start));
}
