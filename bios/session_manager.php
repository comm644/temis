<?php

require_once( dirname( __FILE__ ) . '/../singleton/Singleton.php' );


class session_manager_impl extends Singleton
{
	static function start_session()
	{
		@session_start();
	}

	static function init()
	{
		if ( !class_exists( 'session_manager' ) ) {
			$instance = new session_manager_impl();
			$instance->createFrontend('session_manager');
		}
	}
}


session_manager_impl::init();
	
//only for Eclipce intellisence
if ( defined("ECLIPCE")) {
	class session_manager  extends session_manager_impl{};
}

session_manager::start_session();
