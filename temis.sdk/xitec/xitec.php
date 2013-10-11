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
?>
<?php
/******************************************************************************
 Copyright (c) 2008 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : TEMIS.Xitec
 File       : compiler.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:

   Cross platform implementation xsltproc for compiling Xitec sources
 
******************************************************************************/



class xitec
{
	var $generator;

	function Xitec()
	{
		$this->generator = dirname( __FILE__ ) . "/compiler.xsl";
	}

	static function getInstance()
	{
		if ( PHP_VERSION >= 5 ) {
			return new xitec_php5();
		}
		else return new Xitec_php4();
	}

	function compile( $srcpath, $destpath )
	{
	}


	function main($argc, $argv)
	{
		if ( $argc < 3 ) return Xitec::usage();

		$src = $argv[1];
		$dest = $argv[2];
		if ( !file_exists( $src ) ) return "Error: $src does not exists";
		
		$xitec = Xitec::getInstance();
			
		$msg = $xitec->compile( $src, $dest );
		if ( $msg != null ) {
			return "Error: " . $msg;
		}
		return null;
	}

	function usage()
	{
		$name = basename( __FILE__ );
		return "TEMIS.Xitec compiler\n"
			."Usage:\n"
			."php {$name} <source.xsl> <destination.xsl>\n"
			;
	}

}

class Xitec_php5 extends Xitec
{
	function compile( $srcpath, $destpath )
	{

		$doc = new DOMDocument();
		$doc->load($this->generator);
		$proc = new xsltProcessor;
		
		$proc->importStyleSheet($doc);

		$xml = new DOMDocument();
		$xml->resolveExternals = true;
		$xml->load( $srcpath);

		if ( $xml == null ) return "can't load $srcpath";
		
		$result = $proc->transformToDoc( $xml );

		if ( !$result ) {
			return "XSL Error";
		}


		$result->standalone=false;
		$result->save( $destpath );

		return null;
	}
}

class Xitec_php4 extends Xitec
{
	function compile( $srcpath, $destpath )
	{
		$proc  = domxml_xslt_stylesheet_file( $this->generator );

		$xml = @domxml_open_file( $srcpath,
			DOMXML_LOAD_PARSING
			| DOMXML_LOAD_SUBSTITUTE_ENTITIES
			| DOMXML_LOAD_COMPLETE_ATTRS, $error );

		if ( $xml == null ) return "can't load $srcpath";

		$proc   = domxml_xslt_stylesheet_doc( $domTemplate );
		$result = $proc->process( $xml );
		
		if ( !$result ) {
			return "XSL Error";
		}

		$result->dump_file( $destpath, false, true);

		return null;
	}
}

?>