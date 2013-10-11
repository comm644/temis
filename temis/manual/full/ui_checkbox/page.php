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
?>
<?php
require_once( dirname( __FILE__ ) . "/../../../temis.php");
require_once( dirname(__FILE__ ) . "/../../../objects/ui-widgets.php" );
require_once( dirname(__FILE__ ) . "/../diagnostics.php" );


class pageTestCheckbox extends uiPage
{
	var $content = "";
	
	function construct()
	{

		$this->checkbox1 = new uiCheckbox();

		$this->checkboxLocalized = new uiCheckbox();
		$this->checkboxXpath = new uiCheckbox();
		

		$this->checkboxClick = new uiCheckbox();
		$this->checkboxClick->onclick->addHandler( 'onclick' );

		$this->checkboxClickAuto = new uiCheckbox();
		$this->checkboxClickAuto->onclick->addHandler( 'onclick' );
		$this->checkboxClickAuto->autoPostBack = true;

		$this->checkboxChange = new uiCheckbox();
		$this->checkboxChange->onchange->addHandler( 'onchange' );

		$this->checkboxChangeAuto = new uiCheckbox();
		$this->checkboxChangeAuto->onchange->addHandler( 'onchange' );
		$this->checkboxChangeAuto->autoPostBack = true;

		$this->checkboxInvisible = new uiCheckbox();
		$this->checkboxInvisible->visible = false;

		$this->checkboxVisible = new uiCheckbox();

		$this->checkboxIndexer = new uiCheckbox();
		$this->checkboxIndexer->checked = array();
		$this->checkboxIndexer->checked[ 0 ] = true;
		$this->checkboxIndexer->checked[ 2 ] = true;

		//group handlers
		$this->checkboxGroups = new uiCheckbox();

		//group items
		$this->checkboxItems = new uiCheckbox();
		$this->checkboxItems->checked = array();
		$this->checkboxItems->checked[ 0 ] = true;
		$this->checkboxItems->checked[ 2 ] = true;

		$this->dyncheckboxItems = new uiCheckbox();
		$this->dyncheckboxItems->checked = array();
		$this->dyncheckboxItems->checked[ 0 ] = true;
		$this->dyncheckboxItems->checked[ 2 ] = true;


		$this->items = array("item1", "item2", "item3" );

		$this->group = $this->mkGroup(
			"root",
			 array(
				 $this->mkGroup( "Group1",
					 array( "item1", "item2" )),
				 $this->mkGroup( "Group2",
					 array( "item3", "item4" ))));
				  
		$this->btnSubmit = new uiButton();
		$this->btnSubmit->onclick->AddHandler( 'onclick' );
	}

	function mkGroup($title, $items )
	{
		$obj = new stdclass;
		$obj->title = $title;
		$obj->items = $items;
		return $obj;
	}

	function onLoad()
	{
		Diag::update( $this );
	}
	
	
	function onclick()
	{
		$this->reload();
	}

	function onchange()
	{
	}

	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page.xsl";
	}

	static function getStateManager()
	{
		return PageState::inView();
	}


}

temis::runpage(  "pageTestCheckbox" );

?>