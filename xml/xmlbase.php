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
  /******************************************************************************
   Copyright (c) 2005 by Alexei V. Vasilyev.  All Rights Reserved.
   -----------------------------------------------------------------------------
   Module     : XML wprapper for using with templates
   File       : xmldoc.php
   Author     : Alexei V. Vasilyev
   -----------------------------------------------------------------------------
   Description:

   required DOMXML for PHP4

  ******************************************************************************/

require_once( dirname( __FILE__ ) . "/../bios/reconv.php" );

if ( !defined( "TEMIS_INT_ENCODING" ) ) define( "TEMIS_INT_ENCODING", "utf-8" );

define( "XMLBASE_LOCALENCODING", TEMIS_INT_ENCODING );


if (  version_compare( PHP_VERSION, "5.0.0" ) == +1) {
	require_once( dirname( __FILE__ ) . "/xmlbase_php5.php" );
	class xmlbase_platform extends xmlbase_php5
	{
	}
}
else {
	require_once( dirname( __FILE__ ) . "/xmlbase_php4.php" );
	class xmlbase_platform extends xmlbase_php4
	{
	}
}


class xmlbase extends xmlbase_platform
{
	var $doc;
	var $root;
	var $xpath;

	// XML BASE

	function xmlbase( $name, $content=NULL, $enc = "UTF-8" )
	{
		if ( $content ) {
			$i=0;
			for( ; $i< strlen( $content ); $i++ ) {
				$c = ord( $content[$i] );
				if ( $c == 32 ) continue;
				if ( $c == 13 ) continue;
				if ( $c == 10 ) continue;
				break;
			}
			$content = substr( $content, $i );

			$gsXML = $content;
		}
		else {
			$gsXML = "<?xml version=\"1.0\" encoding=\"${enc}\"?><$name />";
		}

		$this->doc = $this->_createDoc( $gsXML );

		if ( !$this->doc ) {
			error_log( "Error in:" . $gsXML );
			exit;
		}
		$this->_init();
	}
	function openFile( $file )
	{
		$this->_openFile( $file );
		$this->_init();
	}
	

	function saveFile( $file )
	{
		if( file_exists( $file ) ) unlink( $file );
		$this->_saveFile( $file );
	}

	function newTextNode( $value )
	{
		if ( is_string( $value ) ) {
			$rc = reconv(XMLBASE_LOCALENCODING, "UTF-8", $value, $encoded);
			if ( $encoded !== "" || $rc !== false) {
				$value = $encoded;
			}
		}
		else if ( is_numeric( $value ) ) {
		}
		else if ( is_bool( $value ) ) {
		}
		else if ( !$value ) {
		}
		else {

			print( "Attempt for creating text node from object catched:" );
			print_r( $value );
			print( "--- " );
			Diagnostics::error( "Attempt for creating text node from object catched:");

			$value = "";
		}
		return $this->_createTextNode( $value );
	}

	function insertNode( $node, $root = FALSE  )
	{
		if ( !$root ) $root = $this->root;
		$this->appendChild( $root, $node );
		return( $node );
	}

	/**
	 *
	 * @param string $xpath
	 * @return DOMNode
	 */
	function getSingleNodeByPath( $xpath )
	{
		$nodes =  $this->getNodesByPath( $xpath );
		if ( $nodes === null ) return null;

		return $this->_getItem( $nodes, 0 );
	}
	
	/**
	 *
	 * @param DOMNode $node
	 * @return string
	 */
	function getNodeText( $node )
	{
		if ( !isset( $node ) ) return( "" );
		$value = $this->getContent( $node );

		$value = iconv("UTF-8", XMLBASE_LOCALENCODING, $value);

		return( $value );
	}


	//GET DOC
	
	function getText()
	{
		return( $this->text() );
	}

}


?>
