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
     
     Radio Button
     ========

     Description:

     Radio button
     
       
     Element name:
       
       ui:radio

     Attributes:   

       @id             - object ID
       @value          - value of radio button, xpath available ({source})
       @onclick        - override standard action on click radio, non recomended
       @onchange       - override standard action on change checked, non recomended
       @ui:caption     - radio button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)

       @ui:caption-style - caption text style attribute
       @ui:caption-class - caption text class attribute
       @ui:caption-title - caption text title attribute

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

  <!-- UI button generator -->
  <xsl:template name="ui:radio" match="ui:radio">
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
        <xsl:variable name="wid">
          <xsl:value-of select="/widget/$control-id"/>_<xsl:value-of select="@value"/>
        </xsl:variable>
        
        <input id="{/widget/$wid}" name="{/widget/$control-name}" type="radio" >
	  <xsl:apply-templates select="/widget/." mode="gen:copy-attributes"/>
          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
	    <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="/widget/event">onclick</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
	    <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="/widget/event">onchange</xsl:with-param>
          </xsl:apply-templates>

          
          <xsl:variable name="/object/value">
            <xsl:choose>
              <xsl:when test="contains(/widget/@value, '{')">
                <xsl:attribute name="select">
                  <xsl:value-of select="substring-before( substring-after( /widget/@value, '{'), '}')"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/widget/@value"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="/object/value = $value">
            <xsl:attribute name="/object/checked">1</xsl:attribute>
          </xsl:if>

          <xsl:attribute name="/object/value">
            <xsl:value-of select="/object/$value"/>
          </xsl:attribute>
        </input>
        
        <xsl:if test="count( /widget/@ui:caption ) != 0">
          <a style="text-decoration: none; {@ui:caption-style}" class="{@ui:caption-class}" title="{@ui:caption-title}" href="javascript:void(0);">
            <xsl:attribute name="/object/onclick">
              <xsl:call-template name="/widget/gen:replace-braces">
                <xsl:with-param name="text">
                  <xsl:text/>javascript:_temis.clickWidget('<xsl:value-of select="/widget/$wid"/>');void(0);<xsl:text/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates mode="ui:message" select="/widget/@ui:caption"/>
          </a>
        </xsl:if>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
