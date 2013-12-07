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
if (!defined( 'TEMIS_DIR' ) ) define( 'TEMIS_DIR', dirname(__FILE__) );
				  
class temisTemplate
{

	/**
	 * Gets source code file name for generating default template name.
	 *
	 * @return string
	 */
	function getCodeFile()
	{
		$haveServer= isset( $_SERVER );
		if ($haveServer &&  array_key_exists( "PATH_TRANSLATED", $_SERVER ) ) {
			$codefile = $_SERVER["PATH_TRANSLATED"];
		}
		else if ( $haveServer && array_key_exists( "ORIG_PATH_TRANSLATED", $_SERVER ) ) {
			$codefile = $_SERVER["ORIG_PATH_TRANSLATED"];
		}
		else if ( $haveServer && array_key_exists( "SCRIPT_FILENAME", $_SERVER ) ) {
			$codefile = $_SERVER["SCRIPT_FILENAME"];
		}
		else {
			$codefile =  getcwd() . "/" . $_SERVER[ "argv" ][0];
		}
		return( $codefile );
	}

	/**
	 * 
	 * Apply template to page controller.
	 *
	 * @param uiPage $page
	 * @param TemisSettings $settings  	 Temis global settings.
	 * @return string  generated content
	 */
	function apply( &$page, $settings )
	{
		$result = "";
		$outputFormat = "html";
		
		if ( Temis::isAjax() ){
			$targetId = $_REQUEST["__ajax"];
			$targetIndex = "";
			
			if ( array_key_exists( "__ajax_index", $_REQUEST ) ) {
				$targetIndex = $_REQUEST["__ajax_index"];
			}
				
			$parts = explode("--", $targetId );
			$targetId = array_pop($parts);
			
			$settings->setShowLogo(false);

			//output
			header("Content-Type: text/xml");
			$xml = new PageSerializer( 'ajax' );
			$outputFormat = "xml";
			$xml->serialize( $page, $targetId );
			
			$attr = $xml->newAttr("index", $targetIndex);
			$root = $xml->getSingleNodeByPath("/ajax");
			$xml->appendChild( $root, $attr);
		}
		else {
			$xml = new PageSerializer( "root" );
			$xml->serialize( $page, "page" );
			$outputFormat = $page->getOutputFormat() ;
		}
		
		if ( $page->url == "" ) {
			trigger_error('TEMIS Warning: no URL defined in page: '.$xml->text(), E_USER_WARNING);
			return null;
		}
		
		
		$proc = new UIProcessor($settings);

		$templname = $page->getTemplateName();
		$tmplnameCompiled = $page->getTemplateNameCompiled();

		if ( !file_exists( $templname ) ) {
			trigger_error( "Template '$templname' was not found!", E_USER_ERROR );
			exit;
		}
		if ( $outputFormat == "pagexsl") {
			$proc->updateTemplate($templname, $tmplnameCompiled);
			/* @var $doc DOMComment */
			$doc = $xml->doc;
			$name = $page->getXmlStylesheetUrl();
			$doc->insertBefore( $doc->createProcessingInstruction('xml-stylesheet', 'type="text/xsl" href="'.$name.'"'), $doc->firstChild);
			header("Content-Type: text/xml");
			return $doc->saveXML();
		}
		else if ( $outputFormat == "pagexml") {
			/* @var $doc DOMComment */
			$doc = $xml->doc;
			header("Content-Type: text/xml");
			return $doc->saveXML();
		}
			
		$result .= $proc->apply( $xml->doc, $templname, $outputFormat, $tmplnameCompiled  );

		if ( $settings->saveXmlTree ) {
			$xml->saveFile( $tmplnameCompiled . ".page.xml");
		}
		return $result;
	}
}
