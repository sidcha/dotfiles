#!/usr/bin/perl -w

my $argc = @ARGV;
open($file, "<", "quote.list") or die "Quote list not found!\n";
my @lines = <$file>;
my $total = @lines;
my $line = int (($total/100) * (rand() * 100));
print $lines[$line];
