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
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui gen"
  version="1.0">

  <xsl:variable name="ajax-address" select="'/ajax'"/>
  
  <xsl:template name="gen-ajax-name">
    <xsl:param name="id"/>
    <xsl:param name="context"/>

    <xsl:text>generated_</xsl:text>
    <xsl:value-of select="$context"/>
    <xsl:text>_</xsl:text>
    <xsl:call-template name="str-replace">
      <xsl:with-param name="search" select="'/'"/>
      <xsl:with-param name="replace" select="'_'"/>
      <xsl:with-param name="subject" select="$id"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="ui:panel">
    <!-- create /root/page  implementation -->
    <xsl:apply-templates select="." mode="implement-panel">
      <xsl:with-param name="context" select="'page'"/>
    </xsl:apply-templates>

    <!-- create /ajax/page stub -->
    <xsl:apply-templates select="." mode="gen-ajax-ref">
      <xsl:with-param name="context" select="'page'"/>
      <xsl:with-param name="address">
        <xsl:value-of select="$ajax-address"/>/<xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- generate stub for ajax page, call generated panel via @mode -->
  <xsl:template match="ui:panel" mode="gen-ajax-ref">
    <xsl:element name="xsl:template">
      <xsl:attribute name="/widget/match">
        <xsl:value-of select="$address"/>
      </xsl:attribute>

      <xsl:element name="xsl:apply-templates">
        <xsl:attribute name="/widget/select">.</xsl:attribute>
        <xsl:attribute name="/widget/mode">
          <xsl:call-template name="/widget/gen-ajax-name">
            <xsl:with-param name="context" select="'page'"/>
            <xsl:with-param name="id" select="@id"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:with-param name="/object/ui-page">
          <xsl:attribute name="/widget/select">
            <xsl:value-of select="$address"/>
          </xsl:attribute>
        </xsl:with-param>
        
        <xsl:if test="count(/widget/@ui:index) != 0">
          <xsl:with-param name="/object/ui-index">
            <xsl:attribute name="/widget/select">
              <xsl:apply-templates select="." mode="gen:index">
                <xsl:with-param name="inline" select="'xpath'"/>
                <xsl:with-param name="context" select="'code'"/>
              </xsl:apply-templates>
            </xsl:attribute>
          </xsl:with-param>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ui:panel" mode="implement-panel">
    <xsl:param name="/widget/context"/>
    
    <xsl:param name="/widget/id"><xsl:apply-templates select="." mode="gen:sender-id"/></xsl:param>
    <xsl:param name="/widget/control-id"><xsl:apply-templates select="." mode="gen:control-id"/></xsl:param>
    <xsl:param name="/widget/control-name"><xsl:apply-templates select="." mode="gen:control-name"/></xsl:param>

    <xsl:variable name="holder">
      <xsl:choose>
        <xsl:when test="count(@ui:place-holder)!=0">
          <xsl:value-of select="@ui:place-holder"/>
        </xsl:when>
        <xsl:otherwise>DIV</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:call-template name="gen:newline"/>

    <xsl:element name="xsl:template">
      <xsl:choose>
        <xsl:when test="/widget/$context = 'page'">
          <xsl:attribute name="/widget/match">*</xsl:attribute>
          <xsl:attribute name="/widget/mode">
            <xsl:call-template name="gen-ajax-name">
              <xsl:with-param name="context" select="$context"/>
              <xsl:with-param name="id" select="@id"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="/widget/$context = 'ajax'">
          <xsl:attribute name="/widget/match">
            <xsl:value-of select="$address"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">UI Panel error: Unknown context. please choose 'page' or 'ajax'</xsl:message>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:param name="/object/ui-page">
        <xsl:attribute name="/widget/select">
          <xsl:value-of select="/widget/$address"/>
        </xsl:attribute>
      </xsl:param>
      <xsl:param name="/object/ui-index">
        <xsl:attribute name="/widget/select">/ajax/@index</xsl:attribute>
      </xsl:param>

      <xsl:element name="{/widget/$holder}">
        <xsl:apply-templates select="." mode="gen:copy-attributes"/>
        
        <xsl:attribute name="/object/id">
          <xitec:switch-mode mode="object">
            <xsl:text>
              <xsl:value-of select="/widget/$control-id"/>
            </xsl:text>
          </xitec:switch-mode>
          <xsl:if test="/object/$ui-index != ''">
            <xsl:value-of select="concat('-',/object/$ui-index)"/>
          </xsl:if>
        </xsl:attribute>
        
        <xsl:apply-templates select="*|node()">
          <xsl:with-param name="address">$ui-page</xsl:with-param>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:template[@match='/']">
    <xsl:element name="xsl:template">
      <xsl:attribute name="match">/root/page</xsl:attribute>
      <xsl:if test="@mode !=''">
        <xsl:attribute name="mode"><xsl:value-of select="@mode"/></xsl:attribute>
      </xsl:if>
	  <xsl:param name="/object/ui-page" select="root/page"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:template">
    <xsl:element name="xsl:template">
      <xsl:apply-templates select="." mode="gen:copy-attributes"/>
	  <xsl:param name="/object/ui-page" select="root/page"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="xsl:apply-templates">
    <xsl:element name="xsl:apply-templates">
      <xsl:apply-templates select="." mode="gen:copy-attributes"/>
	  <xsl:with-param name="/object/ui-page" select="/object/$ui-page"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="xsl:call-template">
    <xsl:element name="xsl:call-template">
      <xsl:apply-templates select="." mode="gen:copy-attributes"/>
	  <xsl:with-param name="/object/ui-page" select="/object/$ui-page"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ui:insert-panel">
    <xsl:element name="xsl:apply-templates">
      <xsl:attribute name="/widget/select"><xsl:value-of select="/widget/$address"/></xsl:attribute>
      <xsl:attribute name="/widget/mode">
        <xsl:call-template name="/widget/gen-ajax-name">
          <xsl:with-param name="context" select="'page'"/>
          <xsl:with-param name="id" select="@id"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:with-param name="/object/ui-page">
        <xsl:attribute name="/widget/select">
          <xsl:value-of select="/widget/$address"/>
        </xsl:attribute>
      </xsl:with-param>

      <xsl:if test="count(/widget/@ui:index) != 0">
        <xsl:with-param name="/object/ui-index">
          <xsl:attribute name="/widget/select">
            <xsl:apply-templates select="." mode="gen:index">
              <xsl:with-param name="inline" select="'xpath'"/>
              <xsl:with-param name="context" select="'code'"/>
            </xsl:apply-templates>
          </xsl:attribute>
        </xsl:with-param>
      </xsl:if>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>


