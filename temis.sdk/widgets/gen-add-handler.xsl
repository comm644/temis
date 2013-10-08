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
  xmlns:macro="macros.dtd"
  version="1.0">

  <xsl:template name="gen:select-handler-context">
    <xsl:param name="text"/>
    <xsl:param name="context"/>

    <xsl:choose>
      <xsl:when test="/widget/$context = 'inline'">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gen:replace-braces">
          <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="gen:create-event">
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

        <xsl:if test="$event = ''">
      <xsl:message  terminate="yes" >param 'event' is not defined</xsl:message>
    </xsl:if>
    
    <xsl:variable name="receiver">
      <xsl:call-template name="gen:select-handler-context">
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="text">
          <xsl:apply-templates select="/widget/." mode="gen:object-id">
            <xsl:with-param name="context" select="'noindex'"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="target">
      <xsl:if test="count(@ui:target) != 0">
        <xsl:call-template name="gen:select-handler-context">
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="text">
            <xsl:apply-templates select="/widget/." mode="gen:object-id">
              <xsl:with-param name="id" select="@ui:target"/>
              <xsl:with-param name="context" select="'noindex'"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="target-index">
      <xsl:if test="count(@ui:target-index) != 0">
        <xsl:call-template name="gen:select-handler-context">
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="text">
            <xsl:apply-templates select="/widget/." mode="gen:index">
              <xsl:with-param name="index" select="@ui:target-index"/>
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="context" select="'event'"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="index">
      <xsl:call-template name="gen:select-handler-context">
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="text">
          <xsl:apply-templates select="/widget/." mode="gen:index">
            <xsl:with-param name="inline" select="'yes'"/>
            <xsl:with-param name="context" select="'event'"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:text/>_temis.createEvent('<xsl:value-of select="/widget/$event"/><xsl:text>'</xsl:text>
    <xsl:text/>,'<xsl:copy-of select="/widget/$receiver"/>'<xsl:text/>
    <xsl:if test="count(@ui:index) !=0">
      <xsl:text/>,'<xsl:copy-of select="/widget/$index"/>'<xsl:text/> <!-- object self index -->
    </xsl:if>
    <xsl:text>)</xsl:text>
    <!-- targeting -->
    <xsl:text/>,_temis.createTarget(<xsl:text/>
    <xsl:text/>'<xsl:copy-of select="/widget/$target"/>'<xsl:text/>
    <xsl:text/>,'<xsl:copy-of select="/widget/$target-index"/>'<xsl:text/>
    <xsl:if test="count(@ui:window) !=0">
      <xsl:text/>,'<xsl:value-of select="/widget/@ui:window"/>'<xsl:text/>
    </xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="*" mode="gen:handler-code">
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

    <xsl:text>_temis.sendMessage(this,</xsl:text>
    <xsl:apply-templates select="/widget/." mode="gen:create-event">
      <xsl:with-param name="event" select="$event"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
    <xsl:text>);</xsl:text>
    
  </xsl:template>

  <xsl:template match="*" mode="gen:add-handler">
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

    <xsl:if test="count( /widget/@*[ name() = $event ] ) = 0">
      
      <xsl:choose>
        <xsl:when test="$event = 'onclick'">
          <xsl:if test="count( /object/onclick/handlers/* ) != 0 and /object/autoPostBack = '1'">
            <xsl:attribute>
              <xsl:attribute name="/widget/name"><xsl:value-of select="/widget/$event"/></xsl:attribute>
              <xsl:value-of select="/widget/@ui:before-onclick"/>
              <xsl:apply-templates select="/widget/." mode="gen:handler-code">
                <xsl:with-param name="event" select="/widget/$event"/>
                <xsl:with-param name="context" select="/widget/$context"/>
              </xsl:apply-templates>
            </xsl:attribute>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$event = 'onchange'">
          <xsl:if test="count( /object/onchange/handlers/* ) != 0 and /object/autoPostBack = '1'">
            <xsl:attribute>
              <xsl:attribute name="/widget/name"><xsl:value-of select="/widget/$event"/></xsl:attribute>
              <xsl:value-of select="/widget/@ui:before-onchange"/>
              <xsl:apply-templates select="/widget/." mode="gen:handler-code">
                <xsl:with-param name="event" select="/widget/$event"/>
                <xsl:with-param name="context" select="/widget/$context"/>
              </xsl:apply-templates>
            </xsl:attribute>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <xsl:template match="*" mode="gen:get-handler">
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

    <xsl:if test="count( /widget/@*[ name() = $event ] ) = 0">
      <xsl:choose>
        <xsl:when test="$event = 'onclick'">
          <xsl:if test="count( /object/onclick/handlers/* ) != 0 and /object/autoPostBack = '1'">
            <xsl:apply-templates select="/widget/." mode="gen:handler-code">
              <xsl:with-param name="event" select="/widget/$event"/>
              <xsl:with-param name="context" select="/widget/$context"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$event = 'onchange'">
          <xsl:if test="count( /object/onchange/handlers/* ) != 0 and /object/autoPostBack = '1'">
            <xsl:apply-templates select="/widget/." mode="gen:handler-code">
              <xsl:with-param name="event" select="/widget/$event"/>
              <xsl:with-param name="context" select="/widget/$context"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    
  </xsl:template>
  
  
</xsl:stylesheet>
