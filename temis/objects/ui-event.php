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
 Copyright (c) 2007 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : Event invoker
 File       : ui-event.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/

/**
 * Event handler class describes one event handler.
 */
class EventHandler
{
	/**
	 * Hanlder method.
	 * @var string
	 */
	var $method;

	/**
	 * Owner object name for building dispatching code.
	 * Usually 'page', but can be some another
	 * member of page controller .
	 * 
	 * @var string
	 */
	var $object;

	/**
	 * Construct Event handler.
	 *
	 * @param string $method handler method name
	 * @param string $object handler object name
	 */
	function EventHandler( $method, $object = '$page'  )
	{
		$this->method = $method;
		$this->object = $object;
	}
}

/**
 * Class describes one event type of widget.
 */
class Event
{
	var $handlers = array();

	function Event( $name )
	{
		//$this->name = $name;
	}

	/**
	 * @param $handler string|EventHandler
	 */
	function AddHandler( $handler )
	{
		array_push( $this->handlers, $handler );
	}

	/**
	 * @param $sender Sender
	 * @param $value
	 */
	function Dispatch( $sender, $value )
	{
		global $page;
		
		$object = $sender->Root();

			
		//print_r( $sender );
		foreach( $this->handlers as $handler ){
			if ( is_string( $handler ) ) {
				if ( $sender->object ) {
					$code = '$sender->object->' . $handler . '( $sender, $value );';
				}
			}
			else {
				$code = $handler->object . "->" . $handler->method . '( $sender, $value );';
			}
			//print_r( $code );
			eval( $code );
		}
	}

	/**
	 * Indicates value whether event registered.
	 *
	 * @return bool  True if any handlerare registered.
	 */
	function IsExists()
	{
		return( count( $this->handlers ) != 0 );
	}
}
define( 'CLASS_Event', get_clasS( new Event('class') ));

?>