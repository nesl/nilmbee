open evFile, "$ARGV[0]" or die $!;
$numnodes=22;

for($nodeidx=1; $nodeidx<=$numnodes; $nodeidx++) {
	$onstate[$nodeidx] = 0;
	$offstate[$nodeidx] = 0;
}

while(my $line= <evFile>) {
#	print $line;
	$_=$line;
	@ev=split;
	$node=@ev[0];
	$statechange=@ev[1];
	if($statechange == 1) {
		$onstate[$node]++;
	} else {
		$offstate[$node]++;
	}
}

for($nodeidx=1; $nodeidx<=$numnodes; $nodeidx++) {
	print("NODE = ",$nodeidx, " ONCOUNT = ",$onstate[$nodeidx],"\n");
	print("NODE = ",$nodeidx, " OFFCOUNT = ",$offstate[$nodeidx],"\n");

}



