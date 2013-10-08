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
  /** This file contains settings for TEMIS
   */


//name for pages stored in session or cookies
global $TEMIS_PAGE;
$TEMIS_PAGE = '__temis_page_';

//name for application stored in session or cookies
global $TEMIS_APPLICATION;
$TEMIS_APPLICATION = '__temis_application';

//always save compiled template
global $TEMIS_SAVE_COMPILED_TEMPLATE;
$TEMIS_SAVE_COMPILED_TEMPLATE = true;

//always use compiled template instead original 
global $TEMIS_USE_COMPILED_TEMPLATE;
$TEMIS_USE_COMPILED_TEMPLATE = false;

//show TEMIS logo at bottom of page
global $TEMIS_SHOW_LOGO;
$TEMIS_SHOW_LOGO = true;

//for debug mode. enables testing inheritance
global $TEMIS_ENABLE_TEST_INHERITS;
$TEMIS_ENABLE_TEST_INHERITS = true;

//for testing mode disable page redirects  and others some actions
global $TEMIS_TESTING_MODE;
$TEMIS_TESTING_MODE = false;


?>