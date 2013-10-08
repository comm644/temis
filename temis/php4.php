<?php
/*

   Copyright (c) 2008 Alexey V. Vasilyev

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/
?><?php
  /* module contains functions which is non-exists in php4
   */


if(!function_exists('http_build_query')) {
   function http_build_query( $formdata, $numeric_prefix = null, $key = null ) {
       $res = array();
       foreach ((array)$formdata as $k=>$v) {
           $tmp_key = urlencode(is_int($k) ? $numeric_prefix.$k : $k);
           if ($key) $tmp_key = $key.'['.$tmp_key.']';
           if ( is_array($v) || is_object($v) ) {
               $res[] = http_build_query($v, null /* or $numeric_prefix if you want to add numeric_prefix to all indexes in array*/, $tmp_key);
           } else {
               $res[] = $tmp_key."=".urlencode($v);
           }
           /*
           If you want, you can write this as one string:
           $res[] = ( ( is_array($v) || is_object($v) ) ? http_build_query($v, null, $tmp_key) : $tmp_key."=".urlencode($v) );
           */
       }
       $separator = ini_get('arg_separator.output');
       return implode($separator, $res);
   }
}

if(!function_exists('file_put_contents')) {
	define('FILE_APPEND', 1);
	function file_put_contents($n, $d, $flag = false)
	{
		$mode = ($flag == FILE_APPEND || strtoupper($flag) == 'FILE_APPEND') ? 'a' : 'w';
		$f = @fopen($n, $mode);
		if ($f === false) {
        return 0;
		} else {
			if (is_array($d)) $d = implode($d);
			$bytes_written = fwrite($f, $d);
			fclose($f);
			return $bytes_written;
		}
	}
}
?>