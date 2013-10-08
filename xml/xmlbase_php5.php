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

class xmlbase_php5
{

	function _createDoc( $content )
	{
		$doc = new DOMDocument();
		$doc->loadXML( $content );
		return $this->doc = $doc;
	}

	/** internal function
	 */
	function _init()
	{
		$this->root = $this->doc->documentElement;//obtaining node to delete
		$this->xpath = new DOMXPath( $this->doc );
	}
	
	function _openFile( $file )
	{
		$this->doc = new DOMDocument();
		$this->doc->load( $file );
	}
	function _saveFile( $file )
	{
		$this->doc->formatOutput = true;
		$this->doc->save( $file);
	}
	
	function newNode( $name )
	{
		return( $this->doc->createElement( $name ) );
	}

	function appendChild( &$node, &$child )
	{
		if ( $node == null ) {
			print "<pre>";
			print_r( debug_backtrace() );
			print "</pre>";
		}
		return $node->appendChild( $child );
	}
	
	function _createTextNode( $value )
	{
		return( $this->doc->createTextNode($value) );
	}
	function newAttr( $key, $value )
	{
		$attr = $this->doc->createAttribute( $key);
		$attr->appendChild( $this->newTextNode( $value ) );
		return( $attr );
	}

	//SELECT

	function getNodesByPath( $xpath )
	{
		$xresult= $this->xpath->query( $xpath );
		if ( $xresult ) {
			return( $xresult );
		}
		return( null );
	}
	function _getItem(&$nodes, $index )
	{
		return $nodes->item( $index );
	}
	function getNodesByTag( $root, $tag )
	{
		return( $root->getElementsByTagName( $tag ) );
	}

	function getChildNodes( &$node )
	{
		return( $node->childNodes );
	}
	function getNodeType( &$node )
	{
		return $node->nodeType;
	}	
	function getTagName( &$node )
	{
		return $node->tagName;
	}	
	function getFirstChild( &$node )
	{
		return $node->firstChild;
	}
	function getContent( $node )
	{
		return $node->wholeText;
	}
	
	//GET DATA

	function getAttribute( $node, $attrname )
	{
		if ( get_class( $node ) == "DOMText" ) return( "" );
		return( $node->getAttribute( $attrname ) );
	}
	
	function setAttribute( $node, $attrname, $value )
	{
		return $node->setAttribute( $attrname, $value );
	}
	function getAttributes( &$node )
	{
		return $node->attributes;
	}
	
	// GET DOC
	function text()
	{
		return( $this->doc->saveXML() );
	}

	
}

?>