#!/usr/bin/perl
open EVENTFILE, $ARGV[0] or die $!;
print ("Sleeping for ",$ARGV[0]," and ",$ARGV[1],"\n");
$count=0;
while(my $line = <EVENTFILE>) {
	#print "$line";
	$_=$line;
	@ev = split;
	#Now $ev[0] contains node number
	#$ev[1] contains the state to which we must transition
	#$ev[2] is the time for which we must sleep after sending this event
	system("sudo ./simuevent.py /dev/ttyACM1 $ev[0] $ev[1]");
#	print("Iteration = ",$count,"\n");
	if(($count % 2) == 1) {
		select undef, undef, undef, 2.5;	
	} else {
		select undef, undef, undef, $ARGV[1];
	}
	$count++;
		
	#printf("node = ",$ev[0],$ev[1],"->",$ev[2],"delay=",$ev[3]);

}

