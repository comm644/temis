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
$count = 300;
$maxtries = 3;
function getmicrotime(){
	list($usec, $sec) = explode(" ",microtime());
	return ((float)$usec + (float)$sec);
}

$tmpl = dirname( __FILE__ ) . "/page1.php" .".cxsl";
if ( file_exists( $tmpl ) )unlink( $tmpl );

ob_start();
require_once( dirname( __FILE__ ) . "/page1.php" );
ob_clean();

$TEMIS_USE_COMPILED_TEMPLATE =true;
$TEMIS_SAVE_XMLTREE = false;

$result = 0;
for( $ntries =0; $ntries < $maxtries; $ntries++ )
{	
	$__start = getmicrotime();


	for ( $i=0; $i < $count; $i++ ) {
		ob_start();
		temis::runpage(  "mypage" );
		ob_clean();
	}

	$timespan = getmicrotime() - $__start;
	if ( $result != 0 ) {
		$result = ($result + $timespan) / 2;
	}
	else {
		$result = $timespan;
	}
	ob_start();
	print( sprintf("Total: %3.3f  Per page: %3.3f ", $timespan, $timespan/$count ) ." ");
	print( sprintf("Avg : %3.3f  Per page: %3.3f", $result, $result/$count ) ."\n");
	ob_flush();
}


?>