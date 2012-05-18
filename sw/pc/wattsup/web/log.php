<?php

require_once "db.php";

if ($_REQUEST['token'] != "nilmbee") {
    echo "{\"r\":-1,\"msg\":\"wrong token\"}";
    exit();
}

db_conn();
$data = $_REQUEST['data'];
$id = (int)$_REQUEST['id'];

$data = mysql_real_escape_string($data);

$sql = "insert into log (wattsup_id, timestamp, data) values ($id, now(), '$data')";
$res = mysql_query($sql);

if (mysql_affected_rows() == 1) {
    echo "{\"r\":0,\"msg\":\"ok\"}";
} else {
    $msg = mysql_error();
    echo "{\"r\":-2, \"msg\": \"$msg\"}";
}

