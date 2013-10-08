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


class xslt_php4_xsl
{
	var $xslFromFile = false;
	var $xmlContent = null;
	
	function loadxml( $file )
	{
		$this->sourcexml = $file;
		$this->xmlContent = file_get_contents($this->sourcexml);
		return( $file );
	}

	function openXSLT( $xsltfile )
	{
		$this->xslfile = $xsltfile;
		$this->xslContent = file_get_contents($this->xslfile);
		$this->xslFromFile = true;
		return $xsltfile;
	}

	/** open XSLT from DOM
	 */
	function openDOM( $xsltdom )
	{
		$this->xslfile = null;
		$this->xslContent = $xsltdom;
		$this->xslFromFile = false;
		return $xsltdom;
	}

	function transform( $xml )
	{
		if ( $this->xmlContent == null && is_object( $xml ) ) {
			$this->xmlContent = $xml->dump_mem(true, "utf-8");
		}
		$proc = xslt_create();
		xslt_set_encoding($proc,"utf-8");
		xslt_setopt( $proc, XSLT_SABOPT_DISABLE_STRIPPING | XSLT_SABOPT_DISABLE_ADDING_META );

		if ( $this->xslFromFile ) {
			$xsluri = str_replace( '\\', '/', realpath($this->xslfile) );
			xslt_set_base( $proc, "file://". $xsluri );
		}
		
		$args = array ( '/_xml' => $this->xmlContent, '/_xslt' => $this->xslContent);
		$result = xslt_process($proc, 'arg:/_xml','arg:/_xslt', NULL, $args);
		xslt_free($proc);

		if( $result ) {
			//ok
		}
		else {
			echo "XSLT Error:";
			print_r( $this->xslContent );
		}
		return( $result );
	}

	function getXML($result)
	{
		return $result;
	}
	function getHTML($result)
	{
		return $result;
	}

	function save( $xml, $outfile )
	{
		$fd= fopen( $outfile, "w" );
		fwrite( $fd, $xml );
		fclose( $fd );
	}
}

?>