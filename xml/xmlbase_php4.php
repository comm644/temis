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

class xmlbase_php4
{
	function _createDoc( $content )
	{
		
		return $this->doc = domxml_open_mem($content);
	}

	/** internal function
	 */
	function _init()
	{
		$this->root = $this->doc->document_element();//obtaining node to delete
		$this->xpath = xpath_new_context($this->doc);
	}

	function _openFile( $file )
	{
		$this->doc = domxml_open_file ( $file);
	}
	function _saveFile( $file )
	{
		$this->doc->dump_file( $file, false, true);
	}
	function appendChild( &$node, &$child )
	{
		$node->append_child(  $child );
	}
	function newNode( $name )
	{
		return( $this->doc->create_element( $name ) );
	}
	function _createTextNode( $value )
	{
		return( $this->doc->create_text_node($value) );
	}
	
	function newAttr( $key, $value )
	{
		return( $this->doc->create_attribute( $key, $value) );
	}

	//SELECT

	function getNodesByPath( $xpath )
	{
		$xresult = xpath_eval( $this->xpath, $xpath );
		if ( $xresult ) {
			return( $xresult->nodeset );
		}
		return( null );
	}
	function _getItem($nodes, $index )
	{
		return $nodes[$index];
	}
	function getNodesByTag( $root, $tag )
	{
		return( $root->get_elements_by_tagname( $tag ) );
	}

	function getChildNodes( $node )
	{
		return( $node->child_nodes() );
	}
	function getNodeType( &$node )
	{
		return $node->node_type();
	}	
	function getTagName( &$node )
	{
		return $node->tagname;
	}
	function getFirstChild( &$node )
	{
		return $node->first_child();
	}
	function getContent( $node )
	{
		return $node->get_content();
	}
	
	//GET DATA

	function getAttribute( $node, $attrname )
	{
		foreach( $node->attributes() as $attr ) {
			if ( $attr->name == $attrname ) return( $attr->value );
		}
		return( null );
	}
	function getAttributes( &$node )
	{
		return $node->attributes();
	}
	
	// GET DOC
	function text()
	{
		return( $this->doc->dump_mem(true, "UTF-8") );
	}
}

?>