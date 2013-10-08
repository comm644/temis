<?php

class uiControl
{
	/**control name*/
	var $__name;

	function onLoad( $sender, $selfname )
	{
		if ( $this->__name == "" ) { 
			Diagnostics::error( "Widget name was not set. insert \$page->_temis_initControls() in your custom code" );
		}
	}
	/** system hidden method
	 
	 */
	function _temis_initControls() 
	{
		$members = get_object_vars( $this );
		foreach( $members as $name => $value ) {
			if ( !is_object( $this->$name ) ) continue;
			if ( !is_subclass_of( $this->$name, CLASS_uiWidget ) ) continue;
			$this->$name->__name = $this->__name . "--". $name;
			$this->$name->_temis_initControls();
		}
	}
}

?>