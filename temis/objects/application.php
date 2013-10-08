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

/**
 * This class provides frontend (public signleton interface) 
 * as single entry point for control apllication saving and restoreing
 *
 */
class Application
{
	/**
	 * @static
	 * method provides restoring application data and used by Temis::runpage()   
	 *
	 */
	static function loadState($signForce=false)
	{
		global $Application_instance;
		if ( !$signForce && $Application_instance != null ) return;
		$manager = Application::getManager(); 
		$Application_instance = $manager->restore();
	}
	
	/**
	 * method provides saving application state and used by Temis::runpage()  
	 * @static
	 */
	static function saveState()
	{
		$factory = Application::getManager();
		$app = Application::getInstance();
		
	    	//dbg("store: " . get_class( $app));
		//dbg( Diagnostics::trace() );
		
		$factory->store($app);
	}

	/**
	 * returns current instance. cane used in any place
	 *  
	 * @static 
	 * @return mixed  some Application class wich was defined by ApplicationState
	 */
	static function &getInstance()
	{
		global $Application_instance;
		if ( $Application_instance == null ) {
			$manager = Application::getManager(); 
			$Application_instance = $manager->restore();
		}
		return $Application_instance;
	}
	
	/**
	 * set application signleton instance. internal
	 *
	 * @param Application based $obj
	 * @static 
	 * @access private 
	 */
	static function setInstance(&$obj)
	{
//	    dbg("restore: " . get_class( $obj));
//	    dbg( Diagnostics::trace() );
	    
		global $Application_instance;
		$Application_instance = $obj;
	}
	
	
	
	/**
	 * register Application class state manager . if tou whant register your own manager, you should 
	 * run Application::registerState(new YourOwnManager())  before Temis::runpage()
	 * 
	 * @static 
	 * @param any_class $instance
	 */
	static function registerManager( $manager )
	{
		global $Application_stateManager;
		
		if ( !is_subclass_of($manager, CLASS_ApplicationState)) {
			Diagnostics::error( get_class( $manager) . " is not subclass of " . CLASS_ApplicationState);
		}
		$Application_stateManager = $manager;
	}
	
	/**
	 * returns Application class factory
	 * 
	 * @static 
	 * @return ApplicationState
	 */
	static function getManager()
	{
		global $Application_stateManager;
		return $Application_stateManager;
	}
}

//load all available state managers
require_once( dirname( __FILE__ ) . "/application-state.php" );

//register default application state manager.
Application::registerManager(new ApplicationState_session());


?>