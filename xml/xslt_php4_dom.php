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
class xslt_php4_dom
{
	function loadxml( $file )
	{
		$error = array();
		$xml = @domxml_open_file( $file,
			DOMXML_LOAD_PARSING
			| DOMXML_LOAD_SUBSTITUTE_ENTITIES
			| DOMXML_LOAD_COMPLETE_ATTRS, $error );
		
		if( count( $error ) != 0 ){
			foreach( $error as $em ) {
				print( sprintf( "<b>%s:%d:%d</b>: %s<br>\n",
						urldecode( $em["file"] ), $em["line"], $em["col"],
						$em["errormessage"] ) );
			}
		}
		return( $xml );
	}

	function openXSLT( $xsltfile )
	{
		$this->proc = domxml_xslt_stylesheet_file( $xsltfile );
		return $this->proc;
	}
	function openDOM( $xsltdom )
	{
		$this->proc = domxml_xslt_stylesheet_doc( $xsltdom );
		return $this->proc;
	}

	function transform( $xml )
	{
		return $this->proc->process($xml);
	}

	function getXML($result)
	{
		return $this->proc->result_dump_mem($result);
	}
	function getHTML($result)
	{
		return $this->proc->result_dump_mem($result);
	}

	function save( $xml, $outfile )
	{
		$xml->dump_file( $outfile, false, true);
	}
}

?>