<?php

require_once "db.php";

db_conn();

$t1 = (int)$_REQUEST['t1'];
$t2 = (int)$_REQUEST['t2'];
$id = (int)$_REQUEST['id'];

if (!$t2) $t2 = time();
if (!$t1) $t1 = $t2 - 300;

$sql = "select unix_timestamp(timestamp) as t, data as d from log where unix_timestamp(timestamp) > $t1 and unix_timestamp(timestamp) < $t2 and wattsup_id = $id";
$res = mysql_query($sql);

header("Content-Type: text/plain");

while ($data = mysql_fetch_assoc($res)) {
    $d = $data['d'];
    $d = explode(',',$d);
    $d = array(((float)$d[3])/10, ((float)$d[4]/10), ((float)$d[5]/1000), ((float)$d[6]/10), ((float)$d[16]/100), ((float)$d[19]/10));
    echo "${data['t']}\t${d[0]}\t${d[1]}\t${d[2]}\t${d[3]}\t${d[4]}\t${d[5]}\n";
}


