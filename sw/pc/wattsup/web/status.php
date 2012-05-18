<?php

require_once "db.php";

db_conn();

$sql = "select count(*) as c, wattsup_id from log where timestampdiff(MINUTE, timestamp, now()) <= 10 group by wattsup_id";
$res = mysql_query($sql);


echo "<h3>Recent (10min) log counts</h3>";
while ($data = mysql_fetch_assoc($res)) {
    $f = round($data['c'] / 600, 2);
    echo "${data['wattsup_id']} - ${data['c']} - ($f / s) <br/>";
}


