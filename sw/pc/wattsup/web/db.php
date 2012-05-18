<?php
require_once "conf.php";

function db_conn() {
	global $mysql_id,$db_host,$db_user,$db_passwd,$db_name;	
	@$mysql_id = mysql_connect($db_host, $db_user, $db_passwd);
	if ($mysql_id == false or !$mysql_id) {
		echo ("can not connect database: " . mysql_error());
		exit(1);
	}
	@$sel=mysql_select_db($db_name,$mysql_id);	
	if ($sel == false) {
		echo ("can not select database: " . mysql_error());
		exit(1);
	}
	@mysql_query('SET NAMES \'utf8\'');
}

