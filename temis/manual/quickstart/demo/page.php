<?php

//include TEMIS Framework into file
require_once( dirname(__FILE__ ) . "/../../../temis.php" );
$TEMIS_SAVE_COMPILED_TEMPLATE = true;

//inherit your page from base (uiPage is a base base for any user pages )
class page1 extends  uiPage
{
	//construct page controls
	function construct()
	{
		//create some user controls:
		
		//UI control textbox
		$this->tbText = new uiTextbox();
		$this->tbText->onchange->AddHandler( "ontext");

		//UI control button
		$this->btnOK = new uiButton();
		$this->btnOK->onclick->AddHandler( "reload");

		//and some data

		$this->text = "";

	}

	function ontext() {
		$this->text = $this->tbText->text;

		//reset last browser request
		$this->reload(); 
	}
	// add some action handlers
	//  see 'demos/page1.php' 
}

//and run page by TEMIS, can be implemented via Application controller
temis::runpage(  "page1" );
?>
