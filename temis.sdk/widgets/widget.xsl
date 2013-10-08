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
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui gen xsl xitec"
  version="1.0">
  <!--
  xmlns="http://www.w3.org/TR/html4/strict.dtd"
       -->

  <xsl:variable name="readable">yes</xsl:variable>

  <!-- The system variables allows disable  too rarely
       used function for every time using.
       -->

  <!-- enable testing visibility sign
       values: yes|no|test
       
       yes  - enable visibility testing
       no   - disable visibility testing
       test - page defined value via @ui:options: yes|no
       -->
  <xsl:variable name="enable-test-visibility">yes</xsl:variable>

  <!-- enable testing what objects is exists in data or render object anyway -->
  <xsl:variable name="enable-test-object-exists">yes</xsl:variable>

  <!-- enable test what object shoul be disabled -->
  <xsl:variable name="enable-test-disabled">no</xsl:variable>

  <!-- enable use name as caption if caption is not set -->
  <xsl:variable name="enable-name-as-caption">no</xsl:variable>

  <xsl:output method="xml"
    standalone="yes"
    encoding="utf-8"
    cdata-section-elements="script"
    />

  <xitec:switch-mode mode="widget">
	<xsl:include href="../settings/config.xsl"/>
  </xitec:switch-mode>
  
  <xsl:variable name="JSDIR">
    <xsl:value-of select="$TEMIS_ROOT"/><xsl:text>/compiled</xsl:text>
  </xsl:variable>

  <xsl:include href="str-replace.xsl"/>
  <!-- base tempplates -->
  <xsl:include href="copier.xsl"/>
  
  <xsl:include href="gen-test-visibility.xsl"/>
  <xsl:include href="gen-test-disabling.xsl"/>
  <xsl:include href="gen-object-uri.xsl"/>
  <xsl:include href="gen-object-id.xsl"/>
  <xsl:include href="gen-newline.xsl"/>
  <xsl:include href="gen-add-handler.xsl"/>
  <xsl:include href="gen-index.xsl"/>
  <xsl:include href="gen-strip-braces.xsl"/>
  <xsl:include href="gen-copy-attributes.xsl"/>
  <xsl:include href="gen-selected.xsl"/>

  <xsl:include href="ui-system.xsl"/>
  <xsl:include href="ui-messages.xsl"/>
  
  <xsl:include href="ui-button.xsl"/>
  <xsl:include href="ui-radio.xsl"/>
  <xsl:include href="ui-checkbox.xsl"/>
  <xsl:include href="ui-textbox.xsl"/>
  <xsl:include href="ui-value.xsl"/>
  <xsl:include href="ui-dropdownlist.xsl"/>
  <xsl:include href="ui-panel.xsl"/>
  <xsl:include href="ui-nbsp.xsl"/>
  <xsl:include href="ui-visible.xsl"/>
  <xsl:include href="ui-file.xsl"/>

  
  <!-- template -->

  
</xsl:stylesheet>