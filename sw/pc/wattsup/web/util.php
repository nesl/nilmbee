<?php

/*
function mysession_start() {
    global $timeout;
    if (!isset($_SESSION)) {
            session_start();
    }
    $timeout=1200; //timeout threshold
    $now = time();
    if(isset($_SESSION['session_time']) && ($now-$_SESSION['session_time'])>$timeout)
    {
        //time out
        $_SESSION = array();
    }
    $_SESSION['session_time']=$now;
}

class SimpleTempelate {
	public $vars;
	public function __construct($vars) {
		$this->vars = $vars;
	}
	public function callback($matches) {
		if (array_key_exists($matches[1], $this->vars)) {
			return $this->vars[$matches[1]];
		} else {
			return "";
		}
	}
	public function update($vars) {
		$this->vars = $vars;
	}
	public function render($str) {
		return preg_replace_callback('/{{([[:alnum:]_]+)}}/', array($this, "callback"), $str);
	}
	public function render_file($file) {
		$str = file_get_contents($file);
		return preg_replace_callback('/{{([[:alnum:]_]+)}}/', array($this, "callback"), $str);
	}
}

function default_language() {
	if (!isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) 
		return 'zh';
		
    // break up string into pieces (languages and q factors)
	preg_match_all('/([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $lang_parse);

	if (count($lang_parse[1])) {
		// create a list like "en" => 0.8
		$langs = array_combine($lang_parse[1], $lang_parse[4]);
		
		// set default to 1 for any without q factor
		foreach ($langs as $lang => $val) {
			if ($val === '') $langs[$lang] = 1;
		}

		// sort list based on value	
		arsort($langs, SORT_NUMERIC);
	}

	// look through sorted list and use first one that matches our languages
	foreach ($langs as $lang => $val) {
		if (strpos($lang, 'zh') === 0) {
			return 'zh';
		} else if (strpos($lang, 'en') === 0) {
			return 'en';
		} 
	}
	return 'zh';
}

function get_language() {
	if ($_SESSION['lang']) {
		$language = $_SESSION['lang'];
	} else {
		$language = default_language();
	}
	if ($_GET['lang'] == 'en') {
		$language = ($_SESSION['lang'] = 'en');
	} elseif ($_GET['lang'] == 'zh') {
		$language = ($_SESSION['lang'] = 'zh');
	}
	return $language;
}

function read_general($file, $prefix = '')
{
	$vars = array();
	$fp = @fopen($file, "r");
	if ($fp) {
		while (($buffer = fgets($fp, 4096)) !== false) {
			$buffer = trim($buffer);
			if (!strlen($buffer)) break;
			if (preg_match('/^\s*([[:alnum:]_]+)\s*=\s*(.*)\s*$/', $buffer, $matches)) {
				$vars[$prefix . $matches[1]] = $matches[2];
			}
		}
		fclose($fp);
	}
	return $vars;
}

function color_mix($c1, $c2, $m)
{
	$r = $c2[0] * $m + $c1[0] * (1-$m);
	$g = $c2[1] * $m + $c1[1] * (1-$m);
	$b = $c2[2] * $m + $c1[2] * (1-$m);
	return sprintf("#%02x%02x%02x", $r, $g, $b);
}
*/

