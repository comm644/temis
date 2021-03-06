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

class xslTemplate 
{
	//XSLT BASE

	function apply( $doc, $file )
	{
		$xsl = domxml_xslt_stylesheet_file ( $file );
		if ( $xsl == null ) {
			trigger_error( "Can't load XSL {$file}", E_USER_ERROR );
			return;
		}
		$this->result  = $xsl->process($doc);
		return( $xsl->result_dump_mem($this->result) );
	}
}

?>