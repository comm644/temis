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
	function appendAttribute( &$node, $name, $value )
	{
		$attr  = $this->newAttr( $name, $value);
		$this->appendChild( $node, $attr );
		return $node;
	}
	function serializeToNode( &$obj, $name = null, $index=null, $widgetId='page' )
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

		if ( is_a($obj, 'uiControl')) {
			$widgetId = implode('--', array( $widgetId, $name) );
			$attr  = $this->newAttr( "__name", $widgetId);
			$this->appendChild( $node, $attr );


			/*
			$child = $this->newNode('__name');
			$text = $this->newTextNode( $widgetId );
			$this->appendChild( $child, $text );
			$this->appendChild( $node, $child);
			*/
		}
		if ( is_a( $obj, CLASS_Event)){
			return $this->appendAttribute($node, "handled", count( $obj->handlers ));
		}

		$iswidget = is_a($obj, 'uiWidget');
		if ( $iswidget) {
				/** @var $obj uiWidget */
			$this->appendAttribute($node, 'visible', $obj->visible );
			$this->appendAttribute($node, 'autoPostBack', $obj->autoPostBack);
		}

		if ( is_object( $obj ) ) {
			if ( (method_exists($obj, "__serializeAsAttriutes") && $obj->__serializeAsAttriutes()) || isset( $obj->__useattr)) {
				foreach( get_object_vars( $obj ) as $key => $value ) {
					if ( $key == "__useattr") {
						continue;
					}
					if ( $value === NULL || $value === '' || $value === false) {
						continue;
					}
					if ( is_a($value, CLASS_Event) && !$value->isExists()) {
						continue;
					}

					if ( is_scalar($value )) {
						$child= $this->newAttr( $key, $value );
					}
					else {
						$child = $this->serializeToNode( $value, $key, $widgetId );
					}
					$this->appendChild( $node, $child );
				}
			}
			else {
				foreach( get_object_vars( $obj ) as $key => $value ) {
					if ( $value === NULL || $value === '' || $value === false) {
						continue;
					}
					if ( is_a($value, CLASS_Event) && !$value->isExists()) {
						continue;
					}
					if ( $iswidget && ( $key == 'visible' || $key == 'autoPostBack' )){
						continue;
					}

					$child = $this->serializeToNode( $value, $key );
					$this->appendChild( $node, $child );
				}
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
		$rc =  $this->insertNode( $this->serializeToNode( $obj, $name, null, "page" ), $root );
		return( $rc );
	}

};

?>