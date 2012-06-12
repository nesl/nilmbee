open evFile, "$ARGV[0]" or die $!;
$numnodes=22;

for($nodeidx=1; $nodeidx<=$numnodes; $nodeidx++) {
	$currStateCount[$nodeidx] = 0;
	$currState[$nodeix] = 0;
	$onstate[$nodeidx] = 0;
	$offstate[$nodeidx] = 0;
	$seqNo[$nodeix] = -1;
}
$lineNo=1;
while(my $line= <evFile>) {
	$_=$line;
	@ev = split;
	$node = int(@ev[1]);
	$statechange = int(@ev[5]);

	$lastSeq = $seqNo[$node];
	$seqNo[$node] = @ev[4];
	
#	print("node ",$node, "seq no ",$seqNo[$node]," curr state ",$currState[$node], "changed state ",$statechange, "\n");

	$ignore = 0;
	if($currState[$node] == $statechange) 
	{
		#we have to decide if we should ignore this or record this
		$expectedSeq = ($lastSeq+6)%16;
		if($node == 17) {
#			print($lineNo," Node ",$node," lastSeq = ",$lastSeq," expected Seq ",$expectedSeq, " current Seq ",$seqNo[$node]," \n");
		}
		if($seqNo[$node] < $expectedSeq) {
			$ignore = 1;
		}
		if(($expectedSeq < 6) && ($seqNo[$node] > 6)) {
			#we rolled over
			$expectedSeq = $lastSeq+6;
			if(($expectedSeq - $lastSeq) >= 6) {
				$ignore = 1;
			}
		}
		if($seqNo[$nodeidx] == -1) {
			$ignore = 0;
		}
	}
		
		if($ignore == 0) 
		{
#			print("accepted\n");
			$currState[$node] = $statechange;
			$currStateCount[$node] = 0;
			if($statechange == 1) {
				$onstate[$node]++;
		#		print(" Recording onstate for node ",$node,"\n");
			} else {
				$offstate[$node]++;
		#		print(" Recording offstate for node ",$node,"\n");
			}
		} else {
#			print("ignored\n");
		}
	$lineNo++;
}

for($nodeidx=1; $nodeidx<=$numnodes; $nodeidx++) {
	print("NODE = ",$nodeidx, " ONCOUNT = ",$onstate[$nodeidx],"\n");
	print("NODE = ",$nodeidx, " OFFCOUNT = ",$offstate[$nodeidx],"\n");

}


