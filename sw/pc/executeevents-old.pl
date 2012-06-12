#!/usr/bin/perl
open EVENTFILE, $ARGV[0] or die $!;

while(my $line = <EVENTFILE>) {
	#print "$line";
	$_=$line;
	@ev = split;
	#Now $ev[0] contains node number
	#$ev[1] contains the state to which we must transition
	#$ev[2] is the time for which we must sleep after sending this event
	printf("node = $ev[0], $ev[1], delay=$ev[2]\n");
	system("sudo ./simuevent.py /dev/ttyACM1 $ev[0] $ev[1]");
	select undef, undef, undef, $ev[2];	
	#print("Sleeping for $ev[2]\n");

}

