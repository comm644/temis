<?php
if ( !class_exists('Checking') ){
	require_once( dirname( __FILE__ ) ."/setup.class.php" );
}
require_once( dirname( __FILE__ ) ."/check_sablotron.php" );
require_once( dirname( __FILE__ ) ."/../version.php" );

define( "INSTALL_KEY", "__install");
define( "FORM_KEY", "run");
define( "SETTINGS_DIR", Setup::get_realpath( dirname( __FILE__ ) . "/../settings" ));
define( "COMPILED_DIR", Setup::get_realpath( dirname( __FILE__ ) . "/../compiled") );
define( "TEMPL", dirname( __FILE__ ) . "/install.html" );
if (!defined( "TEMIS_DIR" ) ){
	define( "TEMIS_DIR", realpath(dirname( __FILE__ ) . "/..") );
}
?>