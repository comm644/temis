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
 * Base application state manager. provides methods for creating, saving and restoring application.
 */
class ApplicationState
{
	
	/**
	 * store current insance in some repository
	 *
	 * @param Application $instance
	 */
	function store($instance)
	{
	}

	/**
	 * local Application instance from reposititory
	 * 
	 * @return Application instance restored from repository 
	 */
	function restore()
	{
		return $this->create();
	}
}
define( "CLASS_ApplicationState", get_class( new ApplicationState));


/**
 * this class provides saving and restoring application from/to PHP session
 *
 */
class ApplicationState_session extends ApplicationState
{
	/**
	 * Application name used for creating variable in cookie or session
	 *
	 * @return string application name
	 */
	function getName()
	{
		global $TEMIS_APPLICATION;
		return( $TEMIS_APPLICATION );
	}

	
	/**
	 * methos should returns state manager. if you whants use anopther state manager 
	 * then you should ovveride this method
	 *
	 * @return IStateManager  state manager
	 */
	function getStateManager()
	{
		return new session(); //from Temis.BIOS
	}
	
	function restore()
	{
		$manager= $this->getStateManager();

		return $manager->get( $this->getName() );
	}
		
	
	function store($instance)
	{
		$manager= $this->getStateManager();
		$manager->set( $this->getName(), $instance );
	}
}

/**
 * this class rovides saving and restoring applciation state from/to cookie
 *
 */
class ApplicationState_cookie extends ApplicationState
{
	/**
	 * methos should returns state manager. if you whants use anopther state manager 
	 * then you should ovveride this method
	 *
	 * @return IStateManager  state manager
	 */
	static function getStateManager()
	{
		return new cookie();//from Temis.BIOS
	}
}

?>