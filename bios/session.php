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
 Module     : session controller
 File       : session.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description: include this file as first
******************************************************************************/
require_once( dirname( __FILE__ ) . '/../singleton/Singleton.php' );

class session extends Singleton
{
	static function set( $name, $value )
	{
		$value = serialize( $value );
		$_SESSION[ $name ] = $value;
	}

	static function get( $name )
	{
		if ( !array_key_exists( $name, $_SESSION ) ) return( NULL );

		$value = $_SESSION[ $name ];
		if ( !isset( $value ) ) return( NULL );
		return(  unserialize( $value ) );
	}

	function del( $name )
	{
		unset( $_SESSION[ $name ] );
	}

	function exists( $name )
	{
		return( array_key_exists( $name, $_SESSION ) );
	}
}


require_once( dirname( __FILE__ ) . '/session_manager.php' );