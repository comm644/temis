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
require_once( dirname( __FILE__ ) . '/../../xml/xmlbase.php' );
require_once( dirname( __FILE__ ) . '/../../xml/xsltemplate.php' );
require_once( dirname( __FILE__ ) . '/ui-event.php' );


class PageSerializer  extends xmlbase
{
	function serializeToNode( &$obj, $name = null, $index=null )
	{
		if ( !isset( $name ) ) $name = gettype( $obj );


		$node = $this->newNode( $name );

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
				if ( $value === NULL || $value === '' || $value === false) {
					continue;
				}
				if ( is_a($value, CLASS_Event) && !$value->isExists()) {
					continue;
				}
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

	
	function serialize( &$obj, $name=null, $root = FALSE )
	{
		$rc =  $this->insertNode( $this->serializeToNode( $obj, $name ), $root );
		return( $rc );
	}

};

?>