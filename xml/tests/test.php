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
require_once( dirname( __FILE__ ) . "\..\xmlserializer.php" );
require_once( dirname( __FILE__ ) . "\..\xslt_php4_xsl.php" );

class ClassB
{
	var $name;
}

class MyClass
{
	var $myarray;
	var $mydictionary;

	var $mybool;
	var $myint;

	var $myclassB;

	function MyClass() {
	}
}

$var = new MyClass();
$var->myarray =  array( "a", "b", "c" );
$var->mydictionary = array( "a" => "aa", "b" => "bb", "c" => "cc" );
$var->mybool = true;
$var->myint = 10;
$var->myclassB = new ClassB();
$var->myclassB->name = "типа клaсс Б";

$xmlfile  = dirname(__FILE__ ) . "/file.xml";
$xslfile  = dirname(__FILE__ ) . "/file.xsl";
// EXPORT

$docOut = new XmlSerializer( "root", null, "utf-8");
$docOut->serialize( $var );
$docOut->serialize( $var->myarray );
$docOut->saveFile( $xmlfile );

// IMPORT

$docIn = new XmlSerializer( "root");
$docIn->openFile( $xmlfile );
$obj = $docIn->unserialize( "//object" );
//print_r( $obj );

print "ok";



?>