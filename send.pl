#!/usr/bin/perl -w
use strict;
use IO::Socket::INET;
use Time::HiRes qw(sleep);
my $sock = new IO::Socket::INET(PeerAddr => '192.168.3.106',
	PeerPort => 21324,
	Proto => 'udp', Timeout => 1) or die('Error opening socket.');

my @frames = @ARGV;
my $i = 0;

while (1) {
	my $file = $frames[$i++];
    	if ( ! $file ) {
		$i = 0;
	       $file =$frames[$i];
	}
	warn "# $i $file";
	open(my $fh, '<', $file);
	local $/ = undef;
	print $sock "\x02\x05" . <$fh>;
	close($fh);

	exit 0 if $#frames == 0; # single, exit

	sleep 0.05;


}

