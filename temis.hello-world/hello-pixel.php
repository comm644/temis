<?php

//include TEMIS Framework into file
require_once( dirname(__FILE__ ) . "/../temis/temis-compiled.php" );
require_once( dirname( __FILE__ ) ."/pixel/pixel-template.php" );

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
	    $this->url = "http://";
	}
	function getTemplateName()
	{
	    return __FILE__ . ".xsl";
	}
	function getStateManager()
	{
	    return PageState::none();
	}
	
	function createRenderer()
	{
	    return new temisTemplate_Pixel();
	}
	

}

$set = new TemisSettings();
$set->useCompiledTemplate = true;
$set->showLogo = false;
$set->enableSearchInParents = false;
$set->saveXmlTree = false;
//$set->saveCompiledTemplate = true;
$temis = new Temis( $set );


//and run page by TEMIS, can be implemented via Application controller
$temis->runpage(  "hello" );
?>
