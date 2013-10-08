<?php

/*
 This sample displays how to use internal templating.
 And can show perforance for future TMX template engine.
*/


//include TEMIS Framework into file
define( "CWD",dirname(__FILE__ ) );
require_once( CWD . "/../temis/temis-compiled.php" );

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
	    return CWD . "/hello-tmx.php.tpl";
	}
	function getStateManager()
	{
	    return PageState::none();
	}
	
	function createRenderer()
	{
	    return $this;
	}
	function apply(&$page, $settings )
	{
	    require_once( $this->getTemplateName() );
	}
}


//optimize usage
$set = new TemisSettings();
$set->useCompiledTemplate = true;
$set->showLogo = false;
$set->enableSearchInParents = false;
$set->saveXmlTree = false;
//$set->saveCompiledTemplate = true;

//and run page by TEMIS, can be implemented via Application controller
$temis = new Temis( $set );
$temis->runpage(  "hello" );
