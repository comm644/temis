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


$TEMIS_SAVE_COMPILED_TEMPLATE = true;
class pageTestPanel extends uiPage
{
	var $content = "";
	var $counter = 0;
	function construct()
	{
		//<ui:dropdownlist id="dropdown1"/>
		$this->dropdown1 = new uiDropdownlist();
		$this->dropdown1 = new uiDropdownlist();
		$this->dropdown1->items = array( "embed1", "embed2", "embed3" );

		$this->items = array("item1", "item2", "item3" );

		$this->btnUpdate = new uiButton();
		$this->btnUpdate->onclick->AddHandler( 'onupdate' );

		$this->counter = 0;
		$this->mktext();
	}

	function onLoad()
	{
		Diag::update( $this );
	}
	
	function onupdate()
	{
		$this->counter++;
		$this->mktext();
		if ( !array_key_exists( "__ajax", $_REQUEST ) ) {
			//do not execute reload in AJAX
			$this->reload();
		}
	}
	function mktext()
	{
		$this->text = sprintf( "counter= %d", $this->counter);
	}

	function onchange()
	{
	}

	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page.xsl";
	}
}

$temis = new Temis();
$temis->settings->showLogo = false;
$temis->settings->saveCompiledTemplate = true;
$temis->settings->saveXmlTree= true;
$temis->runpage(  "pageTestPanel" );

?>