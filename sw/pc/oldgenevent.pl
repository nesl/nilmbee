#!/usr/bin/perl
$nSens=20;
$numEvents=200;
$probSimul=0.2;
$counter=0;
$avgDelay=0.1; #1second

while($counter<$nSens) {
	$state[$counter]=0;
#	print "$state[$counter]\n";
	$counter++;
}

$counter=0;
while($counter<$numEvents) {
	#generate events
	$prevsensorID = $sensorID;
	$sensorID=int(rand($nSens));
	if($sensorID == $prevsensorID) {
		continue;
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
	if($sim < $probSimul) {
		print "$sensorID $toggleState 0\n";
	} else {
		print "$sensorID $toggleState $avgDelay\n";
	}
	$counter++;
}

