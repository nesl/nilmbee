<?php

require_once "db.php";

db_conn();

$sql = "select count(*) as c, wattsup_id from log where timestamp>=timestampadd(MINUTE, -10, now()) group by wattsup_id";
$res = mysql_query($sql);

header('Refresh: 5');

echo "<h3>Recent (10min) log counts</h3>";
while ($data = mysql_fetch_assoc($res)) {
    $f = round($data['c'] / 600, 2);
    $color = "#080";
    if ($f < 0.46) 
        $color = "#860";
    if ($f < 0.34)
        $color = "#f00";
    echo "<span style=\"color:$color\">${data['wattsup_id']} - ${data['c']} - ($f / s) </span><br/>";
}


