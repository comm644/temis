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
 Module     : Cookie controller
 File       : cookie.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/

require_once( dirname( __FILE__ ) . '/../singleton/Singleton.php' );

class cookieImpl extends Singleton
{
	function set( $name, $val, $expired = null )
	{
		if ( !$expired ) $expired = 60*60*24*7;
		
		$var = base64_encode( gzcompress( serialize( $val ) ) );
		cookie::setcookie( $name, $var, time() + $expired );
	}
	function setstr( $name, $val, $expired = null )
	{
		if ( !$expired ) $expired = 60*60*24*7;
		
		$var = $val;
		cookie::setcookie( $name, $var, time() + $expired );
	}
	
	function get( $name )
	{
		$value = &$_COOKIE[ $name ];
		if ( !isset( $value ) ) return( NULL );
		
		$obj = unserialize( gzuncompress( base64_decode( $value ) ) );
		return( $obj );
	}
	function getstr( $name )
	{
		$value = &$_COOKIE[ $name ];
		if ( !isset( $value ) ) return( NULL );
		
		$obj = $value;
		return( $obj );
	}
	function del( $name )
	{
		unset( $_COOKIE[ $name ] );
		cookie::setcookie( $name, "", time()-3600, "/", null, 1 );
	}

	function setcookie( $name, $value, $expire )
	{
		$_COOKIE[ $name ] = $value; //for next using in current page load
		setcookie( $name, $value, $expire );
	}

	function exists( $name )
	{
		return( array_key_exists( $name, $_COOKIE ) );
	}
	
	static function init()
	{
		$instance = new cookieImpl();
		$instance->createFrontend('cookie');
	}
}

cookieImpl::init();

	
//only for Eclipce intellisence
if ( defined("ECLIPCE")) {
	class cookie  extends cookieImpl{};
}

