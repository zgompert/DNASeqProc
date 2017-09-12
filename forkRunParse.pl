#!/usr/bin/perl
#
# iterates over a series of fastq files to run the parse barcodes script; it takes a single input file with two columns: column one = fastq file, column 2 = barcode file (space sep)
#

use warnings;
use strict;
use Parallel::ForkManager;

my $nproc = 24; ## maximum number of procs to run at once, change as needed


my $filelist = shift(@ARGV);

open(IN, $filelist) or die "failed to open file list\n";

FILES:
while(<IN>){
	$pm->start and next FILES; ## fork here
	$_ =~ m/^\S+\s+\S+/ or print "failed to match $_\n";
	my $fq = $1;
	my $bc = $2;
	system "perl ./scripts/parse_barcodes768.pl $bc $fq\n";
	$pm->finish; ## exit child process
}

$pm->wait_all_children;
