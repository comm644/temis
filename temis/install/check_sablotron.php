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

  /** verify self copying feature
   */
function check_sablotron()
{

	$src = file_get_contents(  dirname( __FILE__ ) . "/check_sablotron.xsl" );
	
	$arguments = array(
		'/_xml' => $src,
		 '/_xsl' => $src
		);

	// Allocate a new XSLT processor
	$xh = xslt_create();

	// Process the document
	$result = xslt_process($xh, 'arg:/_xml', 'arg:/_xsl', NULL, $arguments);
	if (!$result) return false;

	if ( false ) {
		$srcArray = explode( "\n", $src );
		$resArray = explode( "\n", $result );
		print_r( array_diff( $srcArray, $resArray) );
		print_r( array_diff( $resArray, $srcArray ) );
	}
	xslt_free($xh);
	return $src == $result;
}
?>