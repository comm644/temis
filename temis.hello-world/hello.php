<?php

//include TEMIS Framework into file
require_once( dirname(__FILE__ ) . "/../temis/temis-compiled.php" );

// $TEMIS_SAVE_COMPILED_TEMPLATE = true;

//inherit your page from base (uiPage is a base base for any user pages )
class hello extends  uiPage
{
	var $url="/";
	//construct page controls
	function construct()
	{
	    $this->text = "Hello World.";
	}
	function onLoad()
	{
	}
	function getTemplateName()
	{
	    return __FILE__ . ".xsl";
	}
	function getStateManager()
	{
	    return PageState::none();
	}
}

$set = new TemisSettings();
$set->useCompiledTemplate = true;
$set->showLogo = false;
$set->enableSearchInParents = false;
$set->saveXmlTree = false;
$set->saveCompiledTemplate = true;

//and run page by TEMIS, can be implemented via Application controller
$temis = new Temis( $set );
$temis->runpage(  "hello" );
?>
