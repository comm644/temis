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

class xslt_php5
{
	/**
	 * XSLT processor
	 * @var xsltProcessor 
	 */
	var $proc;

	
	function loadxml( $file )
	{
		$xml = new DOMDocument();
		$xml->resolveExternals = true;
		//$xml->substituteEntities = true;
		$xml->load( $file);
		return( $xml );
	}

	function openXSLT( $xsltfile )
	{
		$dom = new DOMDocument();
		$dom->load($xsltfile);
		$this->openDOM($dom);
		return( $this->proc );
	}
	
	function openDOM( $xmldom )
	{
		$this->proc = new xsltProcessor;
		$this->proc->importStyleSheet($xmldom);
		return( $this->proc );
	}
	function transform( $xml )
	{
		return $this->proc->transformToDoc( $xml );
	}

	function getXML($result)
	{
		$result->encoding = "utf-8";
		return $result->saveXML();
	}
	function getHTML($result)
	{
		return $result->saveHTML();
	}

	function save( $xml, $outfile )
	{
		$xml->standalone=false;
		$xml->save( $outfile );
	}
}

?>