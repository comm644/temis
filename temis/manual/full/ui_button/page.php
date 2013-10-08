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
require_once( dirname( __FILE__ ) . "/../../../temis.php");
require_once( dirname(__FILE__ ) . "/../../../objects/ui-widgets.php" );
require_once( dirname(__FILE__ ) . "/../diagnostics.php" );


class pageTestButton extends uiPage
{
	function construct()
	{
		$this->btnOK = new uiButton();

		$this->btnWithCaption = new uiButton();
		$this->btnWithCaption->text = "program caption";

		$this->btnIndexed = new uiButton();
		$this->btnIndexed->onclick->addHandler( 'onIndexedClick' );
		
		
		$this->buttonClick = new uiButton();
		$this->buttonClick->onclick->addHandler( 'onclick' );

		// visibility
		
		$this->buttonInvisible = new uiButton();
		$this->buttonInvisible->visible = false;

		$this->buttonVisible = new uiButton();

		$this->btnAjax = new uiButton();
		$this->btnAjax->onclick->addHandler( 'onlclick' );

		$this->items = array( "item1", "item2", "item3" );

		$this->btnClose = new uiButton();
		$this->btnClose->onclick->addHandler( 'close' );

		$this->index = "unpressed";
	}
	function onIndexedClick($sender, $index)
	{
		$this->index = $index;
	}
	
	function onclick()
	{
	}

	function onchange()
	{
	}

	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page.xsl";
	}
	function onLoad()
	{
		Diag::update( $this );
	}
	
}

temis::runpage(  "pageTestButton" );

?>