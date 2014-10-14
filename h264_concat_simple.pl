#! /usr/bin/perl

use strict;
use warnings;
use File::Find;
use Cwd;
use File::Temp qw/tempfile/;
use Data::Dumper;


my $size = qq/960x540/;
my $bitrate = qq/1500000/;
#my $ffmpeg = "/usr/bin/ffmpeg";
my $ffmpeg = "ffmpeg.exe";

my $basedir = Cwd::getcwd() || "";
my $file_pattern = q{\.(h264)$};
my @video_files;




##############################
sub search {
    my $file = $File::Find::name;
    if ($file =~ /${file_pattern}/i) {
		$file =~ s/^\.//;
		
		$file = $basedir . $file;
		push @video_files, $file;
    }
}

##############################
sub dump_filelist {
	my $wh = shift || return;

	foreach (sort @video_files) {
		my $str = "file '" . $_ . "'\n";
		print $wh $str;
	}
}

##############################
$| = 1;
sub main { 
	find(\&search, ".");
	my ($wh, $fname) = tempfile;
	dump_filelist $wh;
	close $wh;
	
	if (!-f $ffmpeg) {
		print `$ffmpeg -f concat  -i $fname -s $size -b:v $bitrate merge.wmv`;
	}

	unlink $fname;
}


##############################
main;



