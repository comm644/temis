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


class pageTestRadio extends uiPage
{
	function construct()
	{

		$this->radio1 = new uiRadioButton();
		

		$this->radioClick = new uiRadioButton();
		$this->radioClick->onclick->addHandler( 'onclick' );

		$this->radioClickAuto = new uiRadioButton();
		$this->radioClickAuto->onclick->addHandler( 'onclick' );
		$this->radioClickAuto->autoPostBack = true;

		$this->radioChange = new uiRadioButton();
		$this->radioChange->onchange->addHandler( 'onchange' );

		$this->radioChangeAuto = new uiRadioButton();
		$this->radioChangeAuto->onchange->addHandler( 'onchange' );
		$this->radioChangeAuto->autoPostBack = true;

		$this->radioInvisible = new uiRadioButton();
		$this->radioInvisible->visible = false;

		$this->radioVisible = new uiRadioButton();

		$this->items[] = "variant 1";
		$this->items[] = "variant 2";
		$this->items[] = "variant 3";
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

	static function getStateManager()
	{
		return PageState::inView();
	}


}

temis::runpage(  "pageTestRadio" );

?>