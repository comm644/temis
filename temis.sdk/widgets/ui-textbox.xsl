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
<!--
     
     Text box 
     ========

     Description:

     Text box 
     
       
     Element name:
       
       ui:textbox

     Attributes:   

       @id             - object ID
       @value          - value of textbox button, xpath available ({source})
       @onchange       - override standard action on change
       @ui:caption     - textbox button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)
       @rows           - number of rows for multiline textbox
       @cols           - number of columns for multiline textbox
       @ui:mode        - (text)|(password)|(multiline)  - textbox mode , (text) by default

     another HTML attrbutes is available
       
     Inner text:
     
       is not used

     -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui gen"
  version="1.0">

  <xsl:template match="*" mode="insert-variable-for-value-of">
    <xsl:variable name="/object/value">
      <xsl:apply-templates select="/widget/." mode="gen-selected">
        <xsl:with-param name="/widget/object-value" select="'text'"/>
      </xsl:apply-templates>
      <!--
      <xsl:choose>
        <xsl:when test="count(/widget/@value) = 0">
          <xsl:value-of select="/object/text"/>
        </xsl:when>
        <xsl:when test="contains(/widget/@value, '{')">
          <xsl:attribute name="select">
            <xsl:value-of select="substring-before( substring-after( /widget/@value, '{'), '}')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/widget/@value"/>
        </xsl:otherwise>
      </xsl:choose>
      -->
    </xsl:variable>
   
  </xsl:template>
  
  <!-- UI button generator -->
  <xsl:template name="ui:textbox" match="ui:textbox">
    <xsl:param name="node" select="."/>

    <xsl:param name="/widget/id">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="context">event</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="/widget/control-id">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="/widget/control-name">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:apply-templates select="/widget/." mode="gen:test-visibility">
      <xsl:with-param name="content">

        <xsl:variable name="/widget/mode">
          <xsl:choose>
            <xsl:when test="count(/widget/@ui:mode ) = 0">text</xsl:when>
            <xsl:when test="/widget/@ui:mode = 'text'">text</xsl:when>
            <xsl:when test="/widget/@ui:mode = 'multiline'">multiline</xsl:when>
            <xsl:when test="/widget/@ui:mode = 'password'">password</xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">
                <xsl:text/>Error: Invalid @ui:mode for <xsl:copy-of select="."/>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        
        <xsl:choose>
          <xsl:when test="/widget/$mode = 'multiline'">
            <textarea id="{/widget/$control-id}" name="{/widget/$control-name}" >
              <xsl:apply-templates select="/widget/." mode="gen:copy-attributes"/>
              <!--
              <xsl:if test="count( /widget/@rows ) != 0">
                <xsl:attribute name="rows"><xsl:value-of select="@rows"/></xsl:attribute>
              </xsl:if>
              <xsl:if test="count( /widget/@cols ) != 0">
                <xsl:attribute name="cols"><xsl:value-of select="@cols"/></xsl:attribute>
              </xsl:if>
              -->

              <xsl:apply-templates select="." mode="insert-variable-for-value-of"/>
              <xsl:value-of select="/object/$value"/>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <input id="{/widget/$control-id}" name="{/widget/$control-name}" type="{$mode}" >
              <xsl:apply-templates select="/widget/." mode="gen:copy-attributes"/>
              
              <xsl:apply-templates select="/widget/." mode="gen:add-handler">
                <xsl:with-param name="/widget/event">onchange</xsl:with-param>
              </xsl:apply-templates>

              <xsl:apply-templates select="." mode="insert-variable-for-value-of"/>
              <xsl:attribute name="/object/value"><xsl:value-of select="/object/$value"/></xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
