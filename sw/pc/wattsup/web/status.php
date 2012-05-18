<?php

require_once "db.php";

db_conn();

$sql = "select count(*) as c, wattsup_id from log where timestamp>=timestampadd(MINUTE, -10, now()) group by wattsup_id";
$res = mysql_query($sql);


echo "<h3>Recent (10min) log counts</h3>";
while ($data = mysql_fetch_assoc($res)) {
    $f = round($data['c'] / 600, 2);
    if ($f < 0.46) 
        $color = "#800";
    else
        $color = "#080";
    echo "<span style=\"color:$color\">${data['wattsup_id']} - ${data['c']} - ($f / s) </span><br/>";
}


