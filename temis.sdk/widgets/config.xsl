<?xml version="1.0" encoding="utf-8"?>
<!-- 

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

-->
<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui xitec"
  version="1.0">

  <temis:variable name="readable">yes</temis:variable>

  <!-- The system variables allows disable  too rarely
       used function for every time using.
       -->

  <!-- enable testing visibility sign
       values: yes|no|test
       
       yes  - enable visibility testing
       no   - disable visibility testing
       test - page defined value via @ui:options: yes|no
       -->
  <temis:variable name="enable-test-visibility">yes</temis:variable>

  <!-- enable testing what objects is exists in data or render object anyway -->
  <temis:variable name="enable-test-object-exists">yes</temis:variable>

  <!-- enable test what object shoul be disabled -->
  <temis:variable name="enable-test-disabled">no</temis:variable>

  <!-- enable use name as caption if caption is not set -->
  <temis:variable name="enable-name-as-caption">no</temis:variable>

  <temis:output method="xml"
    standalone="yes"
    encoding="utf-8"
    cdata-section-elements="script"
    />

  <xitec:include href="../settings/config.xsl"/>

  <temis:variable name="JSDIR">
    <temis:value-of select="$TEMIS_ROOT"/><temis:text>/compiled</temis:text>
  </temis:variable>

  
</temis:stylesheet>