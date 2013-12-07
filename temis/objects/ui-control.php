<?php

class uiControl
{
	/**control name*/
	var $__name;

	function __serializeAsAttributes()
	{
		return 0;
	}

	function onLoad( $sender, $selfname )
	{
		if ( !$selfname ) {
			Diagnostics::error( "Widget ($selfname ) name was not set. " );
		}
	}
}

