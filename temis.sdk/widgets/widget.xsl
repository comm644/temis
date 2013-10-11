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

  <xsl:include href="config.xsl"/>
  

  <xsl:include href="str-replace.xsl"/>

  <!-- helpers -->
  <xsl:include href="gen-index.xsl"/>
  <xsl:include href="gen-event-handler.xsl"/>
  <xsl:include href="gen-strip-braces.xsl"/>
  
  <!-- base tempplates -->
  <xsl:include href="copier.xsl"/>
  <xsl:include href="xsl-copier.xsl"/>
  <xsl:include href="xsl-stylesheet.xsl"/>
  <xsl:include href="xsl-template.xsl"/>


  <!-- widgets -->
  
  <xsl:include href="ui-system.xsl"/>

  <!-- block templates -->
  <xsl:include href="ui-widget.xsl"/>
  <xsl:include href="ui-panel.xsl"/>

  <!-- elements -->
  <xsl:include href="ui-textbox.xsl"/>
  <xsl:include href="ui-button.xsl"/>
  <xsl:include href="ui-value.xsl"/>
  <xsl:include href="ui-dropdownlist.xsl"/>
  <xsl:include href="ui-file.xsl"/>
  <xsl:include href="ui-checkbox.xsl"/>
  <xsl:include href="ui-radio.xsl"/>
  

  <!-- Helper controls -->  
  <xsl:include href="ui-nbsp.xsl"/>
  <xsl:include href="ui-messages.xsl"/>
  <xsl:include href="ui-visible.xsl"/>

  
</xsl:stylesheet>