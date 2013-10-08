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
require_once( dirname( __FILE__ ) . "/xmlbase.php" );
require_once( dirname( __FILE__ ) . "/xsltemplate.php" );


class xmlserializer  extends xmlbase
{
	function serializeToNode( &$obj, $name = null, $index=null )
	{
		if ( !isset( $name ) ) $name = gettype( $obj );
		
		$node = $this->newNode( $name );

		$attr  = $this->newAttr( "type", gettype( $obj ) );
		$this->appendChild( $node, $attr );

		if ( is_object( $obj ) ) {
			$attr  = $this->newAttr( "class", get_class( $obj ) );
			$this->appendChild( $node, $attr );
		}
		if ( isset( $index ) ) {
			$attr  = $this->newAttr( "index", $index );
			$this->appendChild( $node, $attr );
		}

		
		if ( is_object( $obj ) ) {
			foreach( get_object_vars( $obj ) as $key => $value ) {
				$child = $this->serializeToNode( $value, $key );
				$this->appendChild( $node, $child );
			}
		}
		else if( is_array( $obj ) )  {
			foreach( $obj as $key => $value ) {
				$child = $this->serializeToNode( $value, null, $key );
				$this->appendChild( $node, $child );
			}
		}
		else if ( is_resource( $obj ) ){
		}
		else {
			$child = $this->newTextNode($obj);
			$this->appendChild( $node, $child);
		}
		return( $node );
	}


	function unserializeFromNode( &$node )
	{
		$index = null;
		$type = null;
		$class = null;

		if ( !isset( $node ) ) {
			return( null );
		}
		
		foreach( $this->getAttributes($node) as $attr ) {
			switch( $attr->name ) {
			case "type":
				$type = $attr->value;
				break;
			case "class":
				$class = $attr->value;
				break;
			}
		}

		//print( "switch " . $type . "\n" );
		switch( $type ) {
		case "array":
			$obj = array();
			foreach( $this->getChildNodes( $node ) as $child ){
				if ( $this->getNodeType($child) == XML_TEXT_NODE  ) continue;
				$index = $this->getAttribute( $child, "index" );
				$obj[ $index ] = $this->unserializeFromNode($child);
			}
			break;
		case "object":
			$obj = new $class();;
			foreach( $this->getChildNodes( $node ) as $child ){
				if ( $this->getNodeType($child) == XML_TEXT_NODE  ) continue;
				$name = $this->getTagName($child);
				$obj->$name = $this->unserializeFromNode($child);
			}
			break;
		default:
			$text = $this->getFirstChild( $node );
			$obj = $this->getNodeText( $text );
			break;
		}

		return( $obj );
	}

    /**
     *
     * @param <type> $obj
     * @param <type> $name
     * @param <type> $root
     * @return DOMDocument
     */
	function serialize( &$obj, $name=null, $root = FALSE )
	{
		$rc =  $this->insertNode( $this->serializeToNode( $obj, $name ), $root );
		return( $rc );
	}
	function unserialize( $xpath )
	{
		return( $this->unserializeFromNode( $this->getSingleNodeByPath( $xpath ) ) );
	}

};

?>