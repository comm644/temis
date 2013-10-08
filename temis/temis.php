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
/******************************************************************************
 Copyright (c) 2006-2009 by Alexei V. Vasiliev.  All Rights Reserved.
 -----------------------------------------------------------------------------
 Name   : TEMIS: "TEMplate IS..."
 File   : temis.php
 Author : Alexei V. Vasiliev
******************************************************************************/
define( "TEMIS_DIR", dirname( __FILE__ ));

require_once( TEMIS_DIR . "/check-install.php");

require_once( TEMIS_DIR . "/settings/config.php" );
require_once( TEMIS_DIR . "/objects/PhpVersionValidator.php" );

//verify version
$validator = new Temis_PhpVersionValidator();
$validator->verify();
	
require_once( TEMIS_DIR . "/settings.php" );
require_once( TEMIS_DIR . "/../bios/session.php" );
require_once( TEMIS_DIR . "/../bios/cookie.php" );
require_once( TEMIS_DIR . "/../bios/forms.php" );
require_once( TEMIS_DIR . "/objects/PageSerializer.php" );

// TEMIS componets
require_once( TEMIS_DIR . "/objects/ui-processor.php" );
require_once( TEMIS_DIR . "/objects/ui-page.php" );

//system  modules
require_once( TEMIS_DIR . "/objects/actions.php" );
require_once( TEMIS_DIR . "/objects/states.php" );
require_once( TEMIS_DIR . "/objects/location.php" );
require_once( TEMIS_DIR . "/objects/application.php" );
require_once( TEMIS_DIR . "/temis-pagestate.php" );
require_once( TEMIS_DIR . "/temis-template.php" );
	
require_once( TEMIS_DIR . "/temis-widgets.php" );




/**
 * This calss contains all Temis settings
 */
class TemisSettings
{
	/**
	 * Indicathed whether framefowrk can display self logo in page footer.
	 * @var bool
	 */
	var $showLogo;

	/**
	 * Indicates whether TEMIS runned in testing mode.
	 * @var bool
	 */
	var $testingMode;

	/**
	 * Enable search uiPage in parent classes
	 * 
	 * @var bool
	 */
	var $enableSearchInParents;
	
	/**
	 * Indicaes whether need save XML tree for debugging XSLT templates.
	 * 
	 * @var bool
	 */
	var $saveXmlTree;
	
	/**
	 * Indicates whether need save compiled template.
	 * Saving template increases speed but can cause some bugs if template
	 * dependences will be updated.
	 * 
	 * @var bool
	 */
	var $saveCompiledTemplate;


	/**
	 * Indicates whether need use compiled template.
	 * Increases speed.
	 * 
	 * @var bool
	 */
	var $useCompiledTemplate;

	/**
	 * Indicates whether need print rendered content.
	 *
	 * True by default.
	 *
	 * @var bool
	 */
	var $printContent = true;

        /**
         *Directory for compiled templates, if not set then will be used same directory
         * as template.
         *
         * @var string
         */
        var $compiledTemplatesDirectory = null;

	function TemisSettings()
	{
		global $TEMIS_APPLICATION;
		global $TEMIS_PAGE;

		global $TEMIS_SHOW_LOGO;
		global $TEMIS_ENABLE_TEST_INHERITS;
		global $TEMIS_SAVE_COMPILED_TEMPLATE;
		global $TEMIS_SAVE_XMLTREE;
		global $TEMIS_USE_COMPILED_TEMPLATE;
		global $TEMIS_TESTING_MODE;

		$this->showLogo = $TEMIS_SHOW_LOGO;
		$this->testingMode = $TEMIS_TESTING_MODE;
		$this->enableSearchInParents = $TEMIS_ENABLE_TEST_INHERITS;
		$this->saveXmlTree = $TEMIS_SAVE_XMLTREE;
		$this->saveCompiledTemplate = $TEMIS_SAVE_COMPILED_TEMPLATE;
		$this->useCompiledTemplate = $TEMIS_USE_COMPILED_TEMPLATE;
	}

	public function setShowLogo($showLogo) {
		$this->showLogo = $showLogo;
	}

        /**
         * Set special directory for compuled templates.
         *
         * @param string $path
         */
        public function setCompiledTempltesDirectory( $path )
        {
            $this->compiledTemplatesDirectory = $path;
        }
	
}

/**
 * Root Framework class.
 * Incapsulates system methods and common page processing flow.
 */
class Temis
{
	/**
	 * Sign that redirect performed.
	 * @var bool
	 */
	var $signRedirect = false;

	/**
	 * Temis Setings
	 * 
	 * @var TemisSettings
	 */
	var $settings;

	/**
	 * Contruct framework instance
	 *
	 * @param TemisSettings $settings
	 */
	function Temis($settings = null)
	{
		if ( !$settings ) {
			$settings = new TemisSettings();
		}
		$this->settings = $settings;
	}

	/**
	 * Runs page controller.
	 *
	 * This method defined global variable $page.
	 * You can use it in Application Controller.
	 *
	 * @param string $pageclass  page controller class
	 * @return uiPage  created and processed page controller
	 * @access public
	 */
	function run( $pageclass )
	{
		global $page;

		if ( !class_exists( $pageclass ) ) {
			trigger_error( "TEMIS Error: The class '<b>{$pageclass}</b>' is not defined.", E_USER_ERROR );			
			return;
		}

		$page = PageState::load( $pageclass );

		if ( get_class( $page ) == "__PHP_Incomplete_Class" ) {
			print_r( $page );
			trigger_error( "TEMIS Error: Cant load page of '<b>{$pageclass}</b>'.", E_USER_ERROR );			
			return;
		}
		$page->_temis_process();

		PageState::save( $page );
		return( $page );
	}

	
	/** Execute real redirect
	 *
	 * @access private
	 * @global Temis $__temis
	 */
	static function _redirect( $url )
	{
		global $__temis;
		
		if ( $__temis->settings->testingMode ) {
			print( "header: Location: {$url}\n");
			$__temis->signRedirect = true;
			return;
		}
		
		header("Location: {$url}");
		exit;
	}


	/** return true if page loaded as post back
	 */
	static function isPostBack()
	{
		$key = "__postback";
		return array_key_exists($key,  $_POST ) && isset( $_POST[$key] );
	}

	/** return  true if executing AJAX call
	 */
	static function isAjax()
	{
		$key = "__ajax";
		return array_key_exists( "__ajax", $_REQUEST ) && $_POST[$key] != "";
	}

	/**
	 * Run page in application flow.
	 *
	 * \li find class
	 * \li Load application state
	 * \li Run page controller
	 * \li Save Application state
	 *
	 * @global Temis  $__temis
	 * @param string $pageclass
	 * @return null|string  null on error or string on success
	 */
	function runpage( $pageclass )
	{
		if ( !Temis::isInstalled() ) {
			require( TEMIS_DIR . "/install/install.php" );
			exit;
		}
		
		if ( !isset( $this ) ) {
			//static context
			global $__temis;
			$__temis = new Temis(); //register singleton
			return $__temis->runpage( $pageclass );
		}
		else {
			global $__temis;
			$__temis = $this; //export singleton
		}
		
		if ( $this->validateClass($pageclass) !== true) {
			return null;
		}

		$this->onStart();

		Application::loadState();

		$page = $this->run( $pageclass );

		if ( $this->signRedirect ) {
			return null;
		}

		Application::saveState();

		$this->onBeforeRender();

		$tmplEngine = $page->createRenderer();
		$content = $tmplEngine->apply( $page, $this->settings );

		if ( !$this->isAjax() && $this->settings->showLogo ) {
			$content .= "<div style='width: 100%; text-align:center; font-family: arial; font-size: 10px;'>Powered by TEMIS Framework</div>";
		}
		$this->onAfterRender();

		if ( $this->settings->printContent) {
			print $content;
		}
		return $content;
	}

	function validateClass( $pageclass )
	{
		if ( !class_exists( $pageclass ) ) {
			trigger_error( "The class '{$pageclass}' is not found", E_USER_ERROR );
			return false;
		}
		if ( $this->settings->enableSearchInParents ) {
			$parentclass = $pageclass;
			do {
				$parentclass = get_parent_class( $parentclass );
			}
			while( $parentclass != CLASS_uiPage && $parentclass != "" );

			if (  $parentclass != CLASS_uiPage  ) {
				trigger_error( "The class '<b>{$pageclass}</b>' is not subclass of <b>uiPage</b>", E_USER_ERROR );
				return false;
			}
		}
		return true;
	}

	static function isInstalled()
	{
		$key = "__temis_installed";
		if (!session::exists( $key ) ) {
			$required = array(
				"/settings/config.xsl",
				 "/compiled/widget.xsl",
				 "/compiled/temis.js");

			$installed = true;
			foreach( $required as $name ){
				$installed &= file_exists( TEMIS_DIR . $name );
			}
			if ( !$installed ) return false;
				
			session::set( $key,  true);
		}
		return session::get( $key );
	}


	/**
	 * Method called before any processing
	 */
	function onStart()
	{

	}
	
	/**
	 * Method called before rendering.
	 */
	function onBeforeRender()
	{
	}
	
	/**
	 * Method called before rendering.
	 * @global float $__rendertime
	 */
	function onAfterRender()
	{
	}
}
?>