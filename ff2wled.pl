#!/usr/bin/perl -w
use strict;
use IO::Socket::INET;
use Time::HiRes qw(sleep);
my $sock = new IO::Socket::INET(PeerAddr => '192.168.3.106',
	PeerPort => 21324,
	Proto => 'udp', Timeout => 1) or die('Error opening socket.');


my $video = shift @ARGV || die "Usage: $0 video.mov";
my $loop =  $ENV{LOOP} || 1;
my $sleep = $ENV{SLEEP} || 0.05;

my $vf =  '-vf scale=10:10'; # resize to 10x10
   $vf .= ',transpose=0,transpose=2'; # rotate 180
   $vf .= ',eq=gamma=0.7';
#   $vf .= ',eq=gamma=1.5:saturation=1.3';

my $fps = int( 1 / $sleep );

open(my $pipe, '-|', "ffmpeg -i \"$video\" $vf -f image2pipe -pix_fmt rgb24 -vcodec rawvideo -r $fps -");


my @frames;
my $frame;
my $i = 0;

while ( ! eof($pipe) ) {
	read( $pipe, $frame, 300 );
	print $sock "\x02\x05" . $frame;
	print STDERR '+';

	$frames[$i++] = $frame;

	sleep $sleep;

}

while (1) {
	foreach my $frame ( @frames ) {
		print $sock "\x02\x05" . $frame;
		print STDERR '.';
		sleep $sleep;
	}
	print STDERR '|';
}

