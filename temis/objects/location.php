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

class PageLocation
{
	static function getURI()
	{
		$parts = parse_url( $_SERVER[ "REQUEST_URI" ] );
		if ( !array_key_exists( "query", $parts ) ) {
			if ( array_key_exists( "path", $parts ) ) return $parts[ "path" ];
			return "nourl";
		}
		parse_str( $parts[ "query" ], $args );
		unset( $args[ "backurl" ] );
		$parts[ "query" ] =	http_build_query( $args );
		$uri = $parts[ "path" ] . "?" . $parts[ "query" ];
		return( $uri );
	}
		
	/* used if request maked by callPage() */
	static function getPreviousURI()
	{
		$key = "HTTP_REFERER";

		if ( array_key_exists( $key, $_SERVER ) && $_SERVER[$key] != "") {
			$uri = $_SERVER[$key];
		}
		else {
			$key = "backurl";
			$uri = array_key_exists( $key, $_REQUEST ) ? $_REQUEST[ $key ] : "";
		}
		
		if ( $uri != "" ) {
			$parts = parse_url( $uri );
			if ( array_key_exists( "path", $parts ) ) $uri=$parts[ "path" ];
			if ( array_key_exists( "query", $parts ) ) {
				$uri .= "?" . $parts[ "query" ];
			}
		}
		if ( $uri == $_SERVER["REQUEST_URI"] ) return null;
		return( $uri );
	}
}

?>