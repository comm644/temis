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
require_once( dirname( __FILE__ ) . "/ui-event.php" );
require_once( dirname( __FILE__ ) . "/ui-sender.php" );
require_once( dirname( __FILE__ ) . "/ui-control.php" );


class uiWidget extends uiControl
{
	var $visible = true;
	var $autoPostBack = false;

	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);;
		$this->_temis_onLoad( $sender );
	}

	function _temis_onLoad( &$sender ) //system hidden method
	{
		//import all members
		$members = get_object_vars( $this );
		foreach( $members as $name => $value ) {
			if ( !is_object( $this->$name ) ) continue;
			if ( !is_subclass_of( $this->$name, CLASS_uiWidget ) ) continue;
			$this->$name->onLoad( new Sender( 'widget', $this ), $this->{$name}->__name );
		}
	}


	/**
	 * Sets visibility property
	 * 
	 * @param bool $value 
	 */
	function setVisible( $value )
	{
		$this->visible = $value;
	}

	public function getAutoPostBack() {
		return $this->autoPostBack;
	}

	/**
	 * Set automatic postback feature
	 *
	 * @param bool $autoPostBack  true - erfeature enabled, displaed otherwise
	 */
	public function setAutoPostBack($autoPostBack) {
		$this->autoPostBack = $autoPostBack;
	}

	
}

define( "CLASS_uiWidget", get_class( new uiWidget ) );

/** <input type="button|submit"/>
 */
class uiButton extends uiWidget
{
	/**
	 * On click event
	 *
	 * @var Event
	 */
	var $onclick;
	var $text = "";
	var $target = "_self";
	var $autoPostBack = true;

	function uiButton()
	{
		$this->onclick = new Event( 'onclick' );
	}

	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);;
	}
	function isEventDefined()
	{
		return $this->onclick->IsExists();
	}
}

class uiLabel extends uiWidget
{
	var $text ="";

	function onLoad( $sender, $selfname )
	{
	}

	
	//slot
	function setText( $sender, $text )
	{
		$this->text = $text;
	}
}

/** <input type="text|password"/> | <textarea>
 */
class uiTextBox extends uiWidget
{
	/**
	 * On change event
	 * @var Event
	 */
	var $onchange;
	
	/** container entered text or displayedi in text box 
	 * @var string
	 */
	var $text = "";

	function uiTextBox()
	{
		$this->onchange  = new Event( 'onchange' );
	}
	
	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);;
		$signChanged = false;
		
		if ( !array_key_exists( $selfname, $_REQUEST ) ) return;
		
		$text = forms::getValueEx( $selfname, $_REQUEST, false );

		if( $text != $this->text ) $signChanged = true;
		$this->text  = $text;
		
		if ( $signChanged ){
			$this->onchange->dispatch( $sender->ForwardFrom( $this->__name ), $text );
		}
	}
	
	/**
	 * returns entered text
	 *
	 * @return string
	 */
	function getText()
	{
		return $this->text;
	}
	
	/**
	 * Set text value
	 *
	 * @param string $value
	 */
	function setText( $value )
	{
		$this->text = $value;
	}
	
	/**
	 * returns true if 'text' is empty
	 *
	 * @return bool
	 */
	function isEmpty()
	{
		return $this->text == '';
	}
}

/** <input type="radio"/>
 */
class uiRadioButton extends uiWidget
{
	var $value;
	
	/**
	 * On click server event handler 
	 *
	 * @var Event
	 */
	var $onclick;
	
	/**
	 * On change server event handler
	 *
	 * @var Event
	 */
	var $onchange;

	function uiRadioButton()
	{
		$this->onclick = new Event( 'onclick' );
		$this->onchange  = new Event( 'onchange' );
	}

	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);;
		$signChanged = false;
		
		if ( !array_key_exists( $selfname, $_REQUEST ) ) return;
		
		$value = $_REQUEST[ $selfname ];

		if( $value != $this->value ) $signChanged = true;
		$this->value  = $value;
		
		if ( $signChanged ){
			$this->onchange->dispatch( $sender->ForwardFrom( $selfname ), $value );
		}
	}

	public function getValue() {
		return $this->value;
	}

	public function setValue($value) {
		$this->value = $value;
	}
}

/** <input type="checkbox"/>
 */
class uiCheckBox extends uiWidget
{
	var $checked = 0;
	var $onclick;
	var $onchange;

	function uiCheckBox()
	{
		$this->onclick = new Event( 'onclick' );
		$this->onchange  = new Event( 'onchange' );
	}

	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);
		$signChanged = false;
		if ( !Temis::isPostBack()) return;
		
		if ( !array_key_exists( $selfname, $_REQUEST ) ) {
			$checked = 0;

			$signChanged = ( $checked != $this->checked );
			$this->checked  = $checked;
		}
		else if ( is_array( $_REQUEST[$selfname] ) ) {

			if ( !is_array( $this->checked ) ) {
				$this->checked = array();
			}
			$checkedItems = array();
			$signChanged = 0;
			foreach( array_keys( $_REQUEST[$selfname] ) as $index ) {
				$checked = 1;
				$wasChecked  = array_key_exists( $index, $this->checked );
				$signChanged |= ( $checked != $wasChecked );
				$checkedItems[ $index ] = $checked;
			}
			$this->checked  = $checkedItems; //replace by new values
		}
		else {
			$checked = 1;
			$signChanged = ( $checked != $this->checked );
			$this->checked  = $checked;
		}

		if ( $signChanged ){
			$this->onchange->dispatch( $sender->ForwardFrom( $selfname ), $checked );
		}
	}

	/**  Get checked value
	 */
	function getCheckedValue()
	{
		if ( !is_array( $this->checked )) return $this->checked;
		return 0;
	}

	/** Set checked value
	 @param bool  $value
	 */
	function setCheckedValue( $value )
	{
		$this->checked =  $value ? 1 : 0;
	}

	/**
	 * Set checked list. as array of checked indexes (@ui:index) as value.
	 * @param array $array
	 */
	function setCheckedList( $array )
	{
		$this->checked = array();
		foreach($array as $key ) {
			$this->checked[ $key ] = 1;
		}
	}

	/**
	 * Get checked list. Use this method if you define widget with @ui:index
	 * Method returns array which contaiin cheked indexes as values.
	 *
	 * @return array(integer)
	 */
	function getCheckedList()
	{
		if ( !is_array( $this->checked )) $this->checked = array();
		return array_keys( $this->checked );
	}

	
}

/** <select>
 */
class uiDropDownList extends uiWidget
{
	/**
	 * On change event handler.
	 * @var Event
	 */
	var $onchange;
	var $selected;
	var $items = array();

	function uiDropDownList()
	{
		//$this->onclick = new Event( 'onclick' );
		$this->onchange  = new Event( 'onchange' );
	}

	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);
		$signChanged = false;
		
		if ( !array_key_exists( $selfname, $_POST ) ) return;
		
		$selected = $_POST[ $selfname ];

		if( $selected != $this->selected ) $signChanged = true;
		$this->selected  = $selected;
		
 		if ( $signChanged ){
 			$this->onchange->dispatch( $sender->ForwardFrom( $selfname), $selected );
 		}
	}

	/**
	 * set selected index.
	 * @param mixed $value
	 */
	function setSelected( $value )
	{
		$this->selected = $value;
	}

	/**
	 * Get selected index.
	 * @return <type>
	 */
	function getSelected()
	{
		return $this->selected;
	}

	/**
	 * Set displayed in dropdown list items.
	 *
	 * 
	 * @param array(index => name) $items
	 */
	function setItems( $items )
	{
		$this->items = $items;
	}
}


/** &ltinput type="hidden"/&gt;
 */
class uiValue extends uiWidget
{
	/**
	 * Event handler for 'onchange'
	 * @var Event
	 */
	var $onchange;

	/**
	 * Event handler for 'onclick'
	 * @var Event
	 */
	var $onclick;
	var $value = "";
	var $disabled = false;

	function uiValue()
	{
		$this->onchange = new Event( 'onchange' );
		$this->onclick  = new Event( 'onclick' ); //support for _temis.postBackValue
	}
	
	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);
		if ( $this->disabled ) return;
		
		$signChanged = false;
		$array = explode("--", $selfname );
		$visibleName = end( $array );

		if ( array_key_exists( $selfname, $_POST ) ){
			//if exists in POST
			$value = $_POST[ $selfname ];
		}
		else if ( array_key_exists( $visibleName, $_GET ) ){
			//if exists in GET
			$value = $_GET[ $visibleName ];
		}
		else {
			//otherwise = null
			$value = null;
		}

		if( $value != $this->value ) $signChanged = true;
		$this->value  = $value;
		
		if ( $signChanged ){
			$this->onchange->dispatch( $sender->ForwardFrom( $selfname ), $value );
		}
	}

	/**
	 * @return string
	 */
	function getValue ()
	{
		return $this->value;
	}

	/**
	 * @param string $value
	 */
	function setValue ($value)
	{
		$this->value = $value;
	}

}


/** <select>
 */
class uiMultiselect extends uiWidget
{
	var $onchange;
	var $selected;
	var $disabled;
	var $items = array();

	function uiMultiselect()
	{
		$this->onchange  = new Event( 'onchange' );
		$this->selected = array();
		$this->disabled = array();
	}

	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);
		$signChanged = false;
		
		if ( !array_key_exists( $selfname, $_REQUEST ) ) return;
		
		$selected = $_REQUEST[ $selfname ];
		if (is_array(($selected))) 
		{
			$selected = array_keys($selected);
		}
		else {
			$selected = $selected ? explode(":", $selected) : array(); //unpack	
		}
		

		if ( $this->selected != $selected ) $signChanged = true;
		$this->selected  = $selected;
		
		if ( $signChanged ){
			$this->onchange->dispatch( $sender->ForwardFrom( $selfname ), $selected );
		}
	}	
}



/** checkboxes
 */
class uiMulticheck extends uiMultiselect
{
	function onLoad( $sender, $selfname )
	{
		parent::onLoad($sender, $selfname);
		if ( !Temis::isPostBack()) return;
		$signChanged = false;
		
		if ( !array_key_exists( $selfname, $_REQUEST ) ) {
			//empty list
			$selected = array();
		}
		else {
			if ( is_array( $_REQUEST[ $selfname ] ) )
    			    $selected = array_keys( $_REQUEST[ $selfname ] );
		}
		if ( $this->selected != $selected ) $signChanged = true;
		$this->selected  = $selected;
		
		if ( $signChanged ){
			$this->onchange->dispatch( $sender->ForwardFrom( $selfname ), $selected );
		}
	}
}


class uiPanel extends uiWidget
{
}


require_once( dirname( __FILE__ ) . "/ui-file.php"); 
