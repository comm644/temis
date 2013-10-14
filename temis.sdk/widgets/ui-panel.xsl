<?xml version="1.0" encoding="utf-8" standalone="no"?>
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
<!--
     
     Panel  place holder
     ========================

     Description:

     AJAX Panel , which can be reloaded dinamically
       
     Element name:
       
       ui:insert-panel

     Attributes:   

       @id             - reference to panel  ID
       @ui:index       - item index if need for multiplicity (for-each)

     another HTML attrbutes is available
       
     Inner text:
     
       not used, will be ignored



     Panel implementation
     =====================

     Description:

     AJAX Panel , which can be reloaded dinamically
       
     Element name:
       
       ui:panel

     Attributes:   

       @id               - panel ID
       @ui:place-holder  -  tag name for HTML place-holder

     another HTML attrbutes is available
     
     Inner text:
     
       panel content, some HTML and UI tags

     Predefined Variables:
       $ui-page         - reference to page object
       $ui-index        - contains current value of index which was setteed on <ui:insert-panel> call
     
     -->
<temis:stylesheet xmlns:temis="http://www.w3.org/1999/XSL/Transform"
                xmlns:ui="ui.dtd"
                xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
                xmlns:gen="gen.dtd"
                exclude-result-prefixes="ui gen" version="1.0">


  <temis:variable name="ajax-address" select="'/ajax'"/>

  <!-- generate out-of-inline template -->

  <!-- generate template call -->
  <temis:template match="ui:panel">
    <xsl:template match="/ajax/{@id}" name="temis__generated_{@id}">
      <xsl:param name="temis-widget" select="/ajax/{@id}"/>
      <xsl:param name="ui-page" select="$temis-widget"/>
      <xsl:param name="ui-index" select="/ajax/@index"/>

      <xsl:variable name="index">
        <xsl:if test="$ui-index != ''">-<xsl:value-of select="$ui-index"/></xsl:if>
      </xsl:variable>

      <div id="{@id}{{$index}}">
        <temis:apply-templates select="." mode="temis-copy-attributes"/>
        <temis:apply-templates select="*|text()"/>
      </div>
    </xsl:template>
  </temis:template>

  <temis:template match="ui:insert-panel">
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
      <xsl:call-template name="temis__generated_{@id}">
        <xsl:with-param name="temis-widget" select="$temis-widget"/>
        <xsl:with-param name="ui-index"><temis:apply-templates select="@ui:index" mode="gen-index-valueof"/></xsl:with-param>
      </xsl:call-template>
  </temis:template>

</temis:stylesheet>
