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

function error_handler( $errno, $errstr, $errfile, $errline, $errcontext)
 {
 	$trace = debug_backtrace();
 	printd( "In {$errfile}:{$errline}: {$errstr}" );

 	$msg = "Trace: \n";
 	foreach( $trace as $item ) {
 		if ( !array_key_exists( 'file', $item ) ) continue;

 		$file = @$item['file'];
 		$line = @$item['line'];
 		$function = @$item['function'];

 		$msg .= "{$file}:{$line}: In {$function}()\n";
 	}
 	printd( $msg . "\n" );
 }
set_error_handler( "error_handler", E_WARNING | E_NOTICE | E_ERROR);
?>