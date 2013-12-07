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
 Copyright (c) 2006 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : forms helper
 File       : forms.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/
require_once( dirname( __FILE__ ) . "/reconv.php" );

/** namespace for forms
 */
class forms
{
	/**
	 * Get value from query
	 *
	 * @param string $name  value name
	 * @param array $src  source array, default $_POST
	 * @param bool $signTrim   inicates whether need trim spaces.
	 * @return string|array   read and converted value 
	 */
	static function getValue( $name, $src = null, $signTrim = true )
	{
		return( forms::getValueEx( $name, $src === null ? $_POST : $src, true ) );
	}

	
	/** return single normalized value from $src ($_POST)
	 */
	static function getValueEx( $name, $src = null, $signTrim = true )
	{
		if ( !$src ) $src = $_POST;
		if ( !array_key_exists( $name, $src ) ) {
			return( "" );
		}
		$text = $src[ $name ];

		if ( is_array( $text ) ){
			$converted = array();
			foreach( $text as $key=>$value ){
				$converted[ $key ] = forms::convert( $value );
			}
			$text = $converted;
		}
		else {
			$text = forms::convert( $text );
		}
		return(  $text );
	}


	static function convert( $text, $signTrim=true)
	{
		$rc = reconv("utf-8", TEMIS_INT_ENCODING,  $text, $decodedText);
		if ( !$rc ) $text = $decodedText;
		
		if ( get_magic_quotes_gpc() ) {
			$text = stripslashes( $text );
		}
		if ( $signTrim ) $text = trim( $text );
		return(  $text );
	}

	/** load from data into CLASS members (NOT TO OBJECT MEMBERS)
	 */
	static function loadObject( &$obj, $exclude, $src = FALSE, $signTrim=false )
	{
		if ( !$src ) $src = $_POST;

		foreach( get_class_vars( get_class($obj) ) as $key => $value ) {
			if ( is_array( $exclude ) && in_array( $key, $exclude ) ) continue;
			if ( !array_key_exists( $key, $src ) ) continue;
			$obj->$key = forms::getValueEx( $key, $src );
			if ( $signTrim ) {
				$obj->{$key} = trim( $obj->{$key} );
			}
		}
		return( $obj );
	}

	static function loadMember( &$obj, $member )
	{
		$obj->$member  = forms::getValueEx( $member, $_POST );
	}
}
