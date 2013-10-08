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
//disable APC caching, APC/win32  does not work with TEMIS
ini_set("apc.cache_by_default", "0");

require_once( dirname( __FILE__ ) . "/../../../temis.php");
require_once( dirname(__FILE__ ) . "/../../../objects/ui-widgets.php" );
require_once( dirname(__FILE__ ) . "/../diagnostics.php" );


class pageTestDropdownlist extends uiPage
{
	var $content = "";
	
	function construct()
	{

		//<ui:dropdownlist id="dropdown1"/>
		$this->dropdown1 = new uiDropdownlist();

		//<ui:dropdownlist id="dropdownItems"/>
		$this->dropdownItems = new uiDropdownlist();
		$this->dropdownItems->items = array( "embed1", "embed2", "embed3" );
		
		//<ui:dropdownlist id="dropdownSelected"/>
		$this->dropdownSelected = new uiDropdownlist();
		$this->dropdownSelected->items = array( "embed1", "embed2", "embed3" );
		$this->dropdownSelected->selected = 2;
		
		//<ui:dropdownlist id="dropdownTempl">
		//<option value="0">item1</option>
		//<option value="1">item1</option>
		//<option value="2">item2</option>
		//</ui:dropdownlist>
		$this->dropdownTempl = new uiDropdownlist();

		$this->dropdownTemplSelected = new uiDropdownlist();
		$this->dropdownTemplSelected->selected = 2;

		//with extern items (//items)
		$this->dropdownExtern = new uiDropdownlist();
		$this->dropdownExtern->selected = 2;
		
		$this->dropdownIndexed = new uiDropdownlist();
		$this->dropdownIndexed->items = array( "embed1", "embed2", "embed3" );
		$this->dropdownIndexed->selected[0] = 0;
		$this->dropdownIndexed->selected[1] = 1;
		$this->dropdownIndexed->selected[2] = 2;

		$this->dropdownIndexedAuto = new uiDropdownlist();
		$this->dropdownIndexedAuto->selected[0] = 0;
		$this->dropdownIndexedAuto->selected[1] = 1;
		$this->dropdownIndexedAuto->selected[2] = 2;


		$this->dropdownServerAction = new uiDropdownlist();
		$this->dropdownServerAction->onchange->addHandler('onchange');

		$this->dropdownAuto = new uiDropdownlist();
		$this->dropdownAuto->onchange->addHandler('onchange');
		$this->dropdownAuto->autoPostBack = true;

		
		$this->dropdownUserAction = new uiDropdownlist();
		
		
		//visibility tests
		
		$this->dropdownlistInvisible = new uiDropdownlist();
		$this->dropdownlistInvisible->visible = false;

		$this->dropdownlistVisible = new uiDropdownlist();

		$this->items = array(
			"k1" => "item1",
			 "k2" => "item2",
			 "k3" => "item3" );

		$this->btnSubmit = new uiButton();
		$this->btnSubmit->onclick->AddHandler( 'onclick' );

		$this->changeclick = 0;
	}

	function onLoad()
	{
		Diag::update( $this );
	}
	
	
	function onclick()
	{
	}

	function onchange()
	{
		$this->changeclick++;
	}

	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page.xsl";
	}
}

temis::runpage(  "pageTestDropdownlist" );

?>