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


class pageTestTextbox extends uiPage
{
	function construct()
	{
		$this->textbox1 = new uiTextBox();
		$this->textbox1->text = "program defined";
		
		$this->textboxEditable = new uiTextBox();
		$this->textboxDisabled = new uiTextBox();
		$this->textboxReadonly = new uiTextBox();

		$this->textboxPassword  = new uiTextBox();
		$this->textboxMultiline = new uiTextBox();

		$this->textboxInvisible = new uiTextBox();
		$this->textboxInvisible->visible = false;

		$this->textboxVisible = new uiTextBox();


		$this->textboxChangeAuto = new uiTextBox();
		$this->textboxChangeAuto->onchange->AddHandler( 'onchange' );
		$this->textboxChangeAuto->autoPostBack = true;

		$this->items = array("server item1", "server item2", "server item3" );

		$this->textboxIndexer = new uiTextBox();
		$this->textboxIndexer->text["item0"] = "server text0";
		$this->textboxIndexer->text["item1"] = "server text1";
		$this->textboxIndexer->text["item2"] = "server text2";
		$this->textboxIndexer->text["item3"] = "server text3";


		$this->btnSubmit = new uiButton();
		$this->btnSubmit->onclick->AddHandler( 'onclick' );
	}

	function onLoad()
	{
		if (forms::getValueEx("format", $_GET, "") != "xml") {
			Diag::update( $this );
		}
		if ( $this->isPostBack() ) {
				print_r( $_POST );
				exit;
		}
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
	public function getOutputFormat() {
		if (forms::getValueEx("format", $_GET, "") == "xml") {
			return "pagexml";
		}
		if (forms::getValueEx("format", $_GET, "") == "xsl") {
			return "pagexsl";
		}
		return "xhtml";
	}

	static function getStateManager()
	{
		return PageState::inView();
	}

}

$temis = new Temis();
$temis->settings->showLogo = false;
$temis->settings->saveCompiledTemplate = true;
$temis->settings->saveXmlTree= true;
$temis->runpage("pageTestTextbox" );

?>