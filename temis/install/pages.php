<?php
require_once( dirname( __FILE__ ). "/includes.php" );

class Install_TemisPage extends WizardPage
{
	function print_section( $stage )
	{
		include( dirname( __FILE__ ) . "/pages.html" );
	}
		
	function run($rc=true)
	{
		if ( $rc ) {
			$this->print_section( $this->id );
		}
		else {
			$this->print_section( 'failed' );
		}
		return $rc;
	}
}

class Install_TemisGreetings extends Install_TemisPage
{

	function run()
	{
		$checking = new Checking();
		$checking->data = new stdclass;

		//command line switch
		if ( !$checking->isServerMode() ) {
			//show message as assert
			$checking->start( "Checking  Server mode execution" );
			$checking->assert(  false, "Server Required. run this script via HTTP request" );
			exit;
		}

		$_SESSION[dirname( __FILE__ )] = $checking;
		return parent::run();
	}
}


class Install_TemisChecking extends Install_TemisPage
{
	function run()
	{
		$checking = new Checking();
		$checking->start( "Checking  Server mode execution" );
		$checking->assert(  $checking->isServerMode() == true, "Server Required. run this script via HTTP request" );
		if( $checking->isServerMode() != true ) {
			return false;
		}

		$filename = SETTINGS_DIR . "/config.xsl";
		$checking->start( "Checking first installation time" );
		$checking->assert( !file_exists( $filename ), "You have aready configured framework. Please clean ".SETTINGS_DIR);
		if( $checking->isFailed() ) {
			return parent::run( false );
		}

		$checking->start( "Checking PATH_TRANSLATED variables" );

		$checking->data = new stdclass;
		$checking->data->pathTranslated = "";
		if ( array_key_exists( "PATH_TRANSLATED", $_SERVER ) ) {
			$checking->data->pathTranslated = "PATH_TRANSLATED";
		}
		else if ( array_key_exists( "ORIG_PATH_TRANSLATED", $_SERVER ) ) {
			$checking->data->pathTranslated = "ORIG_PATH_TRANSLATED";
		}
		else if ( array_key_exists( "SCRIPT_FILENAME", $_SERVER ) ) {
			$checking->data->pathTranslated = "SCRIPT_FILENAME";
		}
		$checking->assert( $checking->data->pathTranslated !== "", "Script does not know self path" );	

		$checking->start( "Checking  PROJECT location" );

		$system = $_SERVER[$checking->data->pathTranslated];
		$server = $_SERVER["PHP_SELF"];
		$systemLen = strlen( $system );
		$serverLen = strlen( $server );
		$checking->data->docRoot = realpath( substr( $system, 0, $systemLen - $serverLen ) );
		$checking->ok();

		$checking->start( "Checking TEMIS location" );
		$checking->data->temisRoot = str_replace( "\\", "/",
			substr( TEMIS_DIR, strlen( $checking->data->docRoot ) ));
		$checking->ok();
	
		$target = SETTINGS_DIR;
		$checking->start( "Checking writable access to {$target}" );
		$checking->assert( $checking->writable_access( $target), "Do make $target are writable" );

		$target = COMPILED_DIR;
		$checking->start( "Checking writable access to {$target}" );
		$checking->assert( $checking->writable_access( $target), "Do make $target are writable" );
	

		$checking->start( "Checking PHP Version" );
		$checking->data->php5 = version_compare( PHP_VERSION, "5.0.0" ) >= 0;
		$checking->data->phpVersion = PHP_VERSION;
	
		if ( $checking->data->php5 ) {
			$checking->message( "PHP5");

			$checking->start( "Checking DOM support" );
			$checking->assert( class_exists( "DOMDocument"), "Please enable DOM feature");

			$checking->start( "Checking DOMXPath support" );
			$checking->assert( class_exists( "DOMXPath"), "Please enable DOM XPath feature");
		
			$checking->start( "Checking XSLT support" );
			$checking->assert( class_exists( "XSLTProcessor"), "Please enable XSL feature");
		
		}
		else {
			$checking->message( "PHP4");

			$checking->start( "Checking DOM/XML support" );
			$checking->assert( function_exists("domxml_new_doc" ), "Please install DOMXML PECL extension");

			$checking->start( "Checking DOM/XSLT support" );
			$checking->data->haveDOMXSLT = function_exists("domxml_xslt_version" );
			$checking->detect( $checking->data->haveDOMXSLT, "DOM/XSLT not detected.");

			if ( !$checking->data->haveDOMXSLT )
			{
				$checking->start( "Checking Sablotron XSLT support" );
				$checking->data->haveXSLT = function_exists("xslt_backend_version" );
				$checking->detect( $checking->data->haveXSLT, "XSLT not detected");

				if ( $checking->data->haveXSLT ) {
					$checking->start( "Checking Sablotron self processing" );
					$rc = check_sablotron();
					$checking->assert( $rc , "Your version have a bug of coping namespaces.");
					if ( $rc === false ) $checking->data->haveXSLT = false;
				}
			}

			$checking->start( "Checking available XSLT processor" );
			$checking->assert( $checking->data->haveDOMXSLT || $checking->data->haveXSLT, "XSLT processor is not found. Please install.");
		}

		$checking->start( "Checking session support" );
		$checking->assert( function_exists( "session_start"), "Please enable session feature");

		$checking->start( "Checking iconv support" );
		$checking->assert( function_exists("iconv" ), "iconv module required. Please install.");
	
		$checking->start( "Checking Temis.BIOS" );
		$checking->assert( file_exists( TEMIS_DIR . "/../bios/forms.php"), "Please install module.");
		$checking->start( "Checking Temis.Reconv" );
		$checking->assert( file_exists( TEMIS_DIR . "/../bios/reconv.php"), "Please install module.");
		$checking->start( "Checking Temis.XML" );
		$checking->assert( file_exists( TEMIS_DIR . "/../xml/xmlbase.php"), "Please install module.");
	
		//Make desicion
	
		//XML
		if ( $checking->data->php5 ) $checking->data->xmlEngine = "xmlbase_php5";
		else $checking->data->xmlEngine = "xmlbase_php4";
	
		//XSL
		if ( $checking->data->php5 ) $checking->data->xslEngine = "xslt_php5";
		else if ($checking->data->haveDOMXSLT ) $checking->data->xslEngine = "xslt_php4_dom";
		else if ( $checking->data->haveXSLT ) $checking->data->xslEngine = "xslt_php4_xsl";
		else $checking->data->xslEngine = "xslt_engine_undefined";
	
		$_SESSION[dirname( __FILE__ )] = $checking;
		return parent::run( !$checking->isFailed() );
	}
}

class Install_TemisSettings extends Install_TemisPage
{
	function next()
	{
		$checking = $_SESSION[dirname( __FILE__ )];

		$checking->data->internalEncoding = $_REQUEST["encoding"];
		$_SESSION[dirname(__FILE__)] = $checking;

		parent::next();
	}
}

class Install_TemisReview extends Install_TemisPage
{
	function run()
	{
		$checking = $_SESSION[dirname( __FILE__ )];
		$checking->message( "Please verify settings: ". $checking->endl());
		$checking->message( "PROJECT_ROOT = " . $checking->data->docRoot );
		$checking->message( "TEMIS_ROOT  = " . $checking->data->temisRoot );
		$checking->message( "PHP version = " . $checking->data->phpVersion);
		$checking->message( "XSL Engine  = " . $checking->data->xslEngine);
		$checking->message( "XML Engine  = " . $checking->data->xmlEngine);
		$checking->message( "Internal Encoding  = " . $checking->data->internalEncoding);
		return parent::run();
	}
}

class Install_TemisSetup extends Install_TemisPage
{
	function run()
	{
		$checking = $_SESSION[dirname( __FILE__ )];
		$setup = new Setup();

		$setup->start( "Creating directories" );
		$setup->assert( file_exists( SETTINGS_DIR ) || mkdir( SETTINGS_DIR ) === TRUE, "can't to create ".SETTINGS_DIR );
		$setup->assert( file_exists( COMPILED_DIR ) || mkdir( COMPILED_DIR ) === TRUE, "can't to create ".COMPILED_DIR );
		$setup->ok();
	
		$setup->start( "Creating TEMIS XSL config" );

		$templ= file_get_contents( dirname( __FILE__ ) . "/config.xsl.templ" );
		$content = str_replace( '{$TEMIS_ROOT}', $checking->data->temisRoot, $templ );
		$filename = SETTINGS_DIR . "/config.xsl";
		$setup->assert( $fd = fopen($filename, 'w'), "Can't create $filename" );
		$setup->assert(  fwrite ( $fd, $content ), "Can't write to $filename" );
		fclose( $fd );
		$setup->ok();

		$setup->start( "Creating TEMIS PHP config" );
	
		$templ= file_get_contents( dirname( __FILE__ ) . "/config.php.templ" );
		$values = array(
			'{$PATH_TRANSLATED}' => $checking->data->pathTranslated,
			 '{$XSLT_ENGINE}' => $checking->data->xslEngine,
			 '{$XML_ENGINE}' => $checking->data->xmlEngine,
			 '{$INT_ENCODING}' => $checking->data->internalEncoding,
			 '{$PHP_VERSION}' => $checking->data->phpVersion,
			 '{$PHP5}' => $checking->data->php5 ? 'true' : 'false'
		 
			);
		
		$content = str_replace( array_keys( $values ), array_values( $values ), $templ );
	
		$filename = SETTINGS_DIR . "/config.php";
		$setup->assert( $fd = fopen($filename, 'w'), "Can't create $filename" );
		$setup->assert(  fwrite ( $fd, $content ), "Can't write to $filename" );
		fclose( $fd );
		$setup->ok();

		return parent::run(  !$setup->isFailed() );
	}
}

class Install_TemisVerify extends Install_TemisPage
{
	function run()
	{
		$checking = $_SESSION[dirname( __FILE__ )];

		$target = SETTINGS_DIR;
		$checking->start( "Checking readonly access to {$target}" );
		$checking->assert( !$checking->writable_accesS( $target), "Do make $target are read-only");

		$target = COMPILED_DIR;
		$checking->start( "Checking readonly access to {$target}" );
		$checking->assert( !$checking->writable_accesS( $target), "Do make $target are read-only");

		return parent::run(  true );
	}	
}


class Install_TemisBye extends Install_TemisPage
{
	function canMovePrev()
	{
		return false;
	}
}
global $EMBEDDED;

$wizard = new Wizard( md5( __FILE__ ) );
if ( !isset($EMBEDDED) ) {
	$wizard->add( new Install_TemisGreetings( 'greetings', 'Start') );
}
$wizard->add( new Install_TemisChecking( 'checking', 'Checking'));
$wizard->add( new Install_TemisSettings( 'settings', 'Set settings'));
$wizard->add( new Install_TemisReview( 'review', 'Review settings'));
$wizard->add( new Install_TemisSetup( 'setup', 'Setup'));
$wizard->add( new Install_TemisVerify( 'verify', 'Verification'));
if ( !isset($EMBEDDED) ) {
	$wizard->add( new Install_TemisBye( 'bye', 'Finish') );
	$wizard->selectStep();
}
?>