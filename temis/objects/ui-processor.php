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
/******************************************************************************
 Copyright (c) 2005-2008 by Alexei V. Vasilyev.  All Rights Reserved.
 -----------------------------------------------------------------------------
 Module     : UI Template compiler
 File       : processor.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/
require_once( TEMIS_DIR . "/settings/config.php" );
require_once( TEMIS_DIR . "/config.php" );
require_once( TEMIS_DIR . "/../xml/xslt.php" );
require_once( TEMIS_DIR . "/objects/DepsBuilder.php" );

/**
 * This class applies XSLT template to page controller XML.
 */
class UIProcessor
{
	/**
	 * Temis global settings.
	 *
	 * @var TemisSettings
	 */
	var $settings;

	/**
	 * Contruct UI processor.
	 *
	 * @param TemisSettings $settings Temis global settings.
	 */
	function UIProcessor($settings)
	{
		$this->deps = new DepsBuilder();
		$this->settings = $settings;
	}

	/**
	 * Gets XSLT processor
	 * 
	 * @return xslt_php5
	 */
	function getProcessor()
	{
		$class = TEMIS_XSLT_ENGINE;
		return new $class();
	}
	
	function updateTemplate( $templateName, $tmplnameCompiled)
	{
		$proc = $this->getProcessor();
		if ( $this->settings->useCompiledTemplate ) {
			$xslfile = $tmplnameCompiled;
			
			if( $this->deps->isnewest( $xslfile, $templateName ) ) {
				$domTemplate = $proc->loadxml( $xslfile );
			}
		}

		if ( !isset( $domTemplate ) ) {
			$this->compile( $templateName, $tmplnameCompiled, true);
		}
	}
	
	function apply( &$xmldom, &$templateName, $signXmlOutput=false, $templateNameCompiled = null )
	{
		$proc = $this->getProcessor();

		if ( $this->settings->useCompiledTemplate ) {
			if ( !$templateNameCompiled ) {
				$templateNameCompiled  = $this->getCompiledName(  $templateName );
			}
			$xslfile = $templateNameCompiled;
			
			if( $this->deps->isnewest( $xslfile, $templateName ) ) {
				$domTemplate = $proc->loadxml( $xslfile );
			}
		}

		if ( !isset( $domTemplate ) ) {
			$domTemplate = $this->compile( $templateName, $templateNameCompiled, $this->settings->saveCompiledTemplate || $this->settings->useCompiledTemplate);
		}

		$proc->openDOM($domTemplate);
		$result = $proc->transform( $xmldom );
		
		if ( $result === FALSE ) {
			trigger_error("TEMIS Error: XSLT error on applying $templateName. ", E_USER_ERROR);
			exit;
		}
	
		switch( $signXmlOutput ) {
			case "xml": return $proc->getXML( $result );
			case "html": return $proc->getHTML( $result );
			case "xhtml": return $this->xml2xhtml( $proc->getXML( $result ));
		}
	}
	
	/**
	 *  http://www.php.net/manual/ru/domdocument.savexml.php#95252
	 * @param type $xml
	 * @return type
	 */
	function xml2xhtml($xml) 
	{
		return preg_replace_callback('#<(\w+)([^>]*)\s*/>#s', create_function('$m', '
         $xhtml_tags = array("br", "hr", "input", "frame", "img", "area", "link", "col", "base", "basefont", "param");
         return in_array($m[1], $xhtml_tags) ? "<$m[1]$m[2] />" : "<$m[1]$m[2]></$m[1]>";
     '), $xml);
	}

	/**
	 * Compile UI template
	 * 
	 * @param string $templateName  source XSLT template
	 * @param bool $signSave  set true if need save result as XML to disk.
	 * @return DOMDocument  created Xml DOM
	 */
	function compile( $templateName, $templateNameCompiled, $signSave = false)
	{
		$uiGenerator = dirname( __FILE__ ) . "/../compiled/widget.xsl";

		$proc = $this->getProcessor();

		if ( !file_exists( $uiGenerator ) ){
			trigger_error("TEMIS Error: can't find generator file $uiGenerator", E_USER_ERROR);
			exit;
		}
		$proc->openXSLT( $uiGenerator );
		$source = $proc->loadxml( $templateName);
		if ( $source == null ) {
			trigger_error("TEMIS Error: can't load source XML", E_USER_ERROR);
			exit;
		}

		$result = $proc->transform( $source );
		$xml = $result->saveXML();
		$xml = str_replace('xmlns:xsl="content://www.w3.org/1999/XSL/Transform"', '' , $xml);

		$result = new DOMDocument();
		$result->loadXML($xml);

		if ( $result === FALSE ) {
			trigger_error("TEMIS Error: XSLT error on compiling $templateName", E_USER_ERROR);
			exit;
		}



		if ( $signSave ) {
			$this->saveCompiled( $proc, $result, $templateName, $templateNameCompiled );
		}
		return( $result );
	}

	/**
	 * Creates compiled template name
	 * 
	 * @param string $templateName  source template name
	 * @return srting 
	 */
	function getCompiledName( $templateName )
	{
		//TODO:  add here LOCALE suffix/prefix
		//$this->settings->locale
                $dir = ( $this->settings->compiledTemplatesDirectory )
                        ? $this->settings->compiledTemplatesDirectory
                        : dirname( $templateName );

                $cxslPath =$dir. "/" . basename( $templateName, ".xsl" ) . ".cxsl" ;

		return(  $cxslPath);
	}

	/** save compiled template to .cxsl
	 */
	function saveCompiled( &$proc, &$domTemplate, &$templateName, $templateNameCompiled )
	{
		$outfile = $templateNameCompiled;

		if( file_exists( $outfile ) ) unlink( $outfile );
		
		$proc->save( $domTemplate, $outfile );
		$this->deps->mkdeps(  $outfile, $templateName );
	}
}
