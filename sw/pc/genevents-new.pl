#!/usr/bin/perl
$nSens=3;
$numEvents=200;
$probSimul=0.2;
$counter=0;
$avgDelay=2.5; #1second

while($counter<$nSens) {
	$state[$counter]=0;
#	print "$state[$counter]\n";
	$counter++;
}

$counter=0;
$zerogen=0;
while($counter<$numEvents) {
	#generate events
	$prevsensorID = $sensorID;
	$sensorID=1+int(rand($nSens));
	if($prevsensorID == $sensorID) {
		next;
	}
	#we will toggle this ID
	$currState = $state[$sensorID];
	if($currState == 0) {
		$toggleState = 1;
	} else {
		$toggleState = 0;
	}
	$state[$sensorID] = $toggleState;
	
	#what's the delay after this event
	$sim = rand();
	#print "$sim\n";
	if(($sim < $probSimul) && ($zerogen!=1)) {
		print "$sensorID $toggleState 0\n";
		$zerogen=1;
	} else {
		print "$sensorID $toggleState $avgDelay\n";
		$zerogen=0;
	}
	$counter++;
}

