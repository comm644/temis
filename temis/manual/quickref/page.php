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
require_once( dirname( __FILE__ ) . "/../../temis.php");
require_once( dirname(__FILE__ ) . "/../../objects/ui-widgets.php" );


class page_quickref extends uiPage
{
	function construct()
	{
		$this->btnOK = new uiButton();
		$this->rbRadioButton = new uiRadioButton();
		$this->dropdown = new uiDropdownlist();
		$this->dropdown->items = array( 'item1', 'item2', 'item3');
		$this->multicheck = new uiCheckbox();
		$this->cbCheckBox = new uiCheckbox();
		$this->tbText = new uiTextbox();
		
		$this->data = array( 'data1', 'data2' );
		$this->value= new uiValue();

	}
	
	function onLoad()
	{
		if ( $this->isPostBack() ) {
			return;
		}
		
		if ( $this->value->value ) { 
			header("Content-type: text/xml" );
			echo file_get_contents(  basename( $this->value->value ) );
			exit;
		}
	}
	public function getOutputFormat() {
		if (forms::getValueEx("format", $_GET, "") == "xml") {
			return "pagexml";
		}
		if (forms::getValueEx("format", $_GET, "") == "xsl") {
			return "pagexsl";
		}
		return "xhtml";
	}

	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page1.xsl";
	}
}

session_destroy();
$temis = new Temis();
$temis->settings->showLogo = false;
$temis->settings->saveCompiledTemplate = true;
$temis->settings->saveXmlTree= false;
$temis->runpage(  "page_quickref" );

