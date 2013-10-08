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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ui="ui.dtd" xmlns:gen="gen.dtd" xmlns:xitec="xitec.dtd" exclude-result-prefixes="ui gen xsl xitec" version="1.0">
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

  <xsl:output method="xml" standalone="yes" encoding="utf-8" cdata-section-elements="script"/>

  <xsl:include href="../settings/config.xsl"/>
  
  <xsl:variable name="JSDIR">
    <xsl:value-of select="$TEMIS_ROOT"/><xsl:text>/compiled</xsl:text>
  </xsl:variable>

  <xsl:template name="str-replace"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="search"/>
    <xsl:param name="replace"/>
    <xsl:param name="subject"/>
      
    <xsl:choose>
      <xsl:when test="contains($subject,$search)">
        <xsl:value-of select="substring-before($subject,$search)"/>
        <xsl:copy-of select="$replace"/>
        <xsl:call-template name="str-replace"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="search" select="$search"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="subject" select="substring-after($subject,$search)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$subject"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template name="str-remove"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="search"/>
    <xsl:param name="subject"/>

    <xsl:call-template name="str-replace"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="search" select="$search"/>
      <xsl:with-param name="subject" select="."/>
    </xsl:call-template>
  </xsl:template>
  <!-- base tempplates -->
  <xsl:template match="@ui:tooltip"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/><xsl:attribute name="title"><xsl:apply-templates mode="ui:message" select="."><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:attribute></xsl:template><xsl:template match="@*|node()"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
      <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    </xsl:copy>
  </xsl:template><xsl:template match="/"><xsl:param name="node"/>
    <xsl:param name="address">$ui-page</xsl:param>
    <xsl:param name="realaddress">/root/page</xsl:param>
    <xsl:copy>
      <xsl:apply-templates select="@*"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
      <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*" mode="gen:test-visibility"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="content"/>
    
    <xsl:variable name="code">
      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>visible = '1'</xsl:attribute><xsl:call-template name="gen:newline"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:call-template><xsl:copy-of select="$content"/></xsl:element>
    </xsl:variable>

    <xsl:choose>
      <!-- optimization for item -->
      <xsl:when test="@ui:visibility = '1' or @ui:visibility = 'yes' ">
        <xsl:copy-of select="$content"/>
      </xsl:when>

      <xsl:when test="@ui:visibility = '0' or @ui:visibility = 'no' ">
      </xsl:when>

      <xsl:when test="@ui:visibility = 'test'">
        <xsl:copy-of select="$code"/>
      </xsl:when>

      <xsl:when test="$enable-test-visibility='yes'">
        <xsl:copy-of select="$code"/>
      </xsl:when>

      <xsl:when test="$enable-test-visibility='test'">
        <xsl:element name="xsl:choose"><xsl:element name="xsl:when"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>//ui:options/$enable-test-visibility = 'yes'</xsl:attribute><xsl:element name="xsl:copy-of"><xsl:attribute name="select">/$code</xsl:attribute></xsl:element></xsl:element><xsl:element name="xsl:otherwise"><xsl:element name="xsl:copy-of"><xsl:attribute name="select">/$content</xsl:attribute></xsl:element></xsl:element></xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- invalid value -->
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="gen:test-disabling"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:variable name="code">
      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>disabled='1'</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">disabled</xsl:attribute><xsl:text>1</xsl:text></xsl:element></xsl:element>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="@disabled='1' or @disabled='yes' ">
        <!-- nothing todo -->
      </xsl:when>
      <xsl:when test="$enable-test-disabled='yes'">
        <xsl:copy-of select="$code"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- nothing todo -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="gen:object-uri"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:variable name="id">
      <xsl:value-of select="$address"/>
      <xsl:if test="@id != ''">
        <xsl:text/>/<xsl:value-of select="@id"/>
      </xsl:if>
    </xsl:variable>
    
    <!-- strip braces -->
    <xsl:choose>
      <xsl:when test="contains( $id, '{')">
        <xsl:value-of select="substring-before( substring-after( $id, '{'), '}')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="gen:object-id"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="id" select="@id"/>
    <xsl:param name="inline">no</xsl:param>
    <xsl:param name="context">id</xsl:param>

    <xsl:variable name="page-address">
      <xsl:choose>
        <xsl:when test="$address != $realaddress">
          <xsl:choose>
            <xsl:when test="starts-with($realaddress,'/root/')">
              <xsl:value-of select="substring-after($realaddress,'/root/')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        
        <xsl:when test="starts-with($address,'/root/')">
          <xsl:value-of select="substring-after($address,'/root/')"/>
        </xsl:when>
        <xsl:when test="starts-with($address,'/ajax/')">
          <xsl:value-of select="substring-after($address,'/ajax/')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="full-address">
      <xsl:value-of select="$page-address"/>
      <xsl:if test="$id != ''">
        <xsl:text/>/<xsl:value-of select="$id"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="str-replace"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="search">/</xsl:with-param>
      <xsl:with-param name="replace">--</xsl:with-param>
      <xsl:with-param name="subject" select="$full-address"/>
    </xsl:call-template>
    <!--
    <xsl:value-of select="translate( $full-address, '/', '-' )"/>
    -->
 
    <xsl:apply-templates select="." mode="gen:index"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="inline" select="$inline"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
 
  </xsl:template><xsl:template match="*" mode="gen:sender-id"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="context">event</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template><xsl:template match="*" mode="gen:control-id"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="inline">yes</xsl:with-param>
      <xsl:with-param name="context">id</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template><xsl:template match="*" mode="gen:control-name"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="inline">yes</xsl:with-param>
      <xsl:with-param name="context">name</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="gen:newline"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:if test="$readable ='yes'">
    <xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="gen:select-handler-context"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="text"/>
    <xsl:param name="context"/>

    <xsl:choose>
      <xsl:when test="$context = 'inline'">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gen:replace-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="*" mode="gen:create-event"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

        <xsl:if test="$event = ''">
      <xsl:message terminate="yes">param 'event' is not defined</xsl:message>
    </xsl:if>
    
    <xsl:variable name="receiver">
      <xsl:call-template name="gen:select-handler-context"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="text">
          <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="context" select="'noindex'"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="target">
      <xsl:if test="count(@ui:target) != 0">
        <xsl:call-template name="gen:select-handler-context"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="text">
            <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="id" select="@ui:target"/>
              <xsl:with-param name="context" select="'noindex'"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="target-index">
      <xsl:if test="count(@ui:target-index) != 0">
        <xsl:call-template name="gen:select-handler-context"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="text">
            <xsl:apply-templates select="." mode="gen:index"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="index" select="@ui:target-index"/>
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="context" select="'event'"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="index">
      <xsl:call-template name="gen:select-handler-context"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="text">
          <xsl:apply-templates select="." mode="gen:index"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="inline" select="'yes'"/>
            <xsl:with-param name="context" select="'event'"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:text/>_temis.createEvent('<xsl:value-of select="$event"/><xsl:text>'</xsl:text>
    <xsl:text/>,'<xsl:copy-of select="$receiver"/>'<xsl:text/>
    <xsl:if test="count(@ui:index) !=0">
      <xsl:text/>,'<xsl:copy-of select="$index"/>'<xsl:text/> <!-- object self index -->
    </xsl:if>
    <xsl:text>)</xsl:text>
    <!-- targeting -->
    <xsl:text/>,_temis.createTarget(<xsl:text/>
    <xsl:text/>'<xsl:copy-of select="$target"/>'<xsl:text/>
    <xsl:text/>,'<xsl:copy-of select="$target-index"/>'<xsl:text/>
    <xsl:if test="count(@ui:window) !=0">
      <xsl:text/>,'<xsl:value-of select="@ui:window"/>'<xsl:text/>
    </xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:template><xsl:template match="*" mode="gen:handler-code"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

    <xsl:text>_temis.sendMessage(this,</xsl:text>
    <xsl:apply-templates select="." mode="gen:create-event"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="event" select="$event"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
    <xsl:text>);</xsl:text>
    
  </xsl:template><xsl:template match="*" mode="gen:add-handler"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

    <xsl:if test="count( @*[ name() = $event ] ) = 0">
      
      <xsl:choose>
        <xsl:when test="$event = 'onclick'">
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test">count( <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>onclick/handlers/* ) != 0 and <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>autoPostBack = '1'</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name"><xsl:value-of select="$event"/></xsl:attribute><xsl:value-of select="@ui:before-onclick"/><xsl:apply-templates select="." mode="gen:handler-code"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="event" select="$event"/>
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates></xsl:element></xsl:element>
        </xsl:when>
        <xsl:when test="$event = 'onchange'">
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test">count( <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>onchange/handlers/* ) != 0 and <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>autoPostBack = '1'</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name"><xsl:value-of select="$event"/></xsl:attribute><xsl:value-of select="@ui:before-onchange"/><xsl:apply-templates select="." mode="gen:handler-code"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="event" select="$event"/>
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates></xsl:element></xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template><xsl:template match="*" mode="gen:get-handler"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="event"/>
    <xsl:param name="context" select="'inline'"/>

    <xsl:if test="count( @*[ name() = $event ] ) = 0">
      <xsl:choose>
        <xsl:when test="$event = 'onclick'">
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test">count( <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>onclick/handlers/* ) != 0 and <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>autoPostBack = '1'</xsl:attribute><xsl:apply-templates select="." mode="gen:handler-code"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="event" select="$event"/>
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates></xsl:element>
        </xsl:when>
        <xsl:when test="$event = 'onchange'">
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test">count( <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>onchange/handlers/* ) != 0 and <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>autoPostBack = '1'</xsl:attribute><xsl:apply-templates select="." mode="gen:handler-code"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="event" select="$event"/>
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates></xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    
  </xsl:template>
  <xsl:template match="*" mode="gen:index"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="index" select="@ui:index"/>
    <xsl:param name="inline"/>
    <xsl:param name="context">name</xsl:param>

    <xsl:if test="$index!=''">
      
      <xsl:variable name="code">
        <xsl:choose>
          <xsl:when test="$inline='yes'">
            <xsl:value-of select="$index"/>
          </xsl:when>
          <xsl:when test="$inline='xpath' and starts-with( $index, '{')">
            <xsl:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <xsl:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <xsl:text>current()/</xsl:text>
            </xsl:if>
            <xsl:value-of select="$codeline"/>
          </xsl:when>
          <xsl:when test="$inline='xpath' and contains( $index, '{')">
            <xsl:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            
            <xsl:text>concat('</xsl:text>
            <xsl:value-of select="substring-before( $index, '{')"/>
            <xsl:text>',</xsl:text>
            <xsl:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <xsl:text>current()/</xsl:text>
            </xsl:if>
            <xsl:value-of select="$codeline"/>
            <xsl:text>)</xsl:text>
          </xsl:when>
          <xsl:when test="$inline='xpath'">
            <xsl:value-of select="$index"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="xsl:value-of">
              <xsl:attribute name="select">
                <xsl:value-of select="substring-before( substring-after(  $index, '{'), '}')"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$context='id'">
          <!--  <input id="id$id"/> -->
          <xsl:text>--</xsl:text><xsl:copy-of select="$code"/>
        </xsl:when>
        <xsl:when test="$context='name'">
          <!--  <input name="id[index]"/> -->
          <xsl:text>[</xsl:text><xsl:copy-of select="$code"/><xsl:text>]</xsl:text>
        </xsl:when>
        <xsl:when test="$context='noindex'"/>
        <xsl:when test="$context='event'">
          <!--
               js:  cation="event:" + id + ":" + event;

               event:object$object$object:onclick       - without index
               event:object$object$object-index:onclick - with index
               -->
          <xsl:copy-of select="$code"/>
        </xsl:when>
        <xsl:when test="$context='xpath' and contains( $index, '{')">
          <xsl:text/>/*[ @index = <xsl:copy-of select="$code"/>]<xsl:text/>
        </xsl:when>
        <xsl:when test="$context='xpath' ">
          <xsl:text/>/*[ @index = '<xsl:copy-of select="$code"/>']<xsl:text/>
        </xsl:when>
        <xsl:when test="$context='code' ">
          <xsl:copy-of select="$code"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    
  </xsl:template>
  <xsl:template match="@*|node()|text()" mode="gen:strip-braces"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:variable name="text" select="."/>
    <xsl:choose>
      <xsl:when test="contains( $text, '{')">
        <xsl:value-of select="substring-before( substring-after( $text, '{'), '}')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="@*|node()|text()" mode="gen:replace-braces" name="gen:replace-braces"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="text" select="."/>
    
    <xsl:choose>
      <xsl:when test="contains( $text, '{')">
        <xsl:value-of select="substring-before( $text, '{')"/>

        <xsl:variable name="after" select="substring-after( $text, '{')"/>
        <xsl:element name="xsl:value-of">
          <xsl:attribute name="select">
            <xsl:value-of select="substring-before( $after, '}')"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:call-template name="gen:replace-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="text" select="substring-after( $text, '}')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="gen:copy-attributes"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <!-- copy attributes  -->
    <xsl:apply-templates select="@ui:tooltip"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    <xsl:for-each select="@*[not(contains(name(),'ui:') or name() = 'id')]">
      <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="*" mode="gen-selected"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="object-value" select="'selected'"/>
    <xsl:choose>
      <xsl:when test="count(@value) = 0">
        <xsl:call-template name="gen:newline"/><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text></xsl:attribute><xsl:attribute name="select">
            <xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>/<xsl:value-of select="$object-value"/>
            <xsl:apply-templates select="." mode="gen:index"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="inline" select="'xpath'"/>
              <xsl:with-param name="context" select="'xpath'"/>
            </xsl:apply-templates>
          </xsl:attribute></xsl:element>
      </xsl:when>
      <xsl:when test="contains(@value, '{')">
        <xsl:attribute name="select">
          <xsl:value-of select="substring-before( substring-after( @value, '{'), '}')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xsl:include"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:variable name="doc" select="document( current()/@href )"/>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:include' ]"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:variable' ]"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:template' ]"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'ui:panel' ]"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
  </xsl:template><xsl:template match="body"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
      <xsl:choose>
        <xsl:when test="count( @ui:manual-control ) = 0 or @manual-control = 'no'">
          <xsl:call-template name="gen:newline"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:call-template>
          <form onsubmit="return _temis.submit();" name="_main" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
            <xsl:call-template name="ui:sys-script"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:call-template>
            <xsl:call-template name="ui:sys-values"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:call-template>
            <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          </form>
        </xsl:when>
        <xsl:when test="@ui:manual-control = 'yes'">
          <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </xsl:copy>
  </xsl:template><xsl:template match="ui:sys-script" name="ui:sys-script"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <script language="javascript" src="{$JSDIR}/temis.js"/>
  </xsl:template><xsl:template match="ui:sys-values" name="ui:sys-values"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <input type="hidden" name="__postback" value="0"/>
    <input type="hidden" name="__action" value=""/>
    <input type="hidden" name="__value" value=""/>
    <input type="hidden" name="__viewstate">
      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>viewstate</xsl:attribute></xsl:element></xsl:element>
    </input>
    <input type="hidden" name="__selfurl">
      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>url</xsl:attribute></xsl:element></xsl:element>
    </input>
  </xsl:template>
  <xsl:template match="ui:msg|ui:message"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:apply-templates mode="ui:message" select="@id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
  </xsl:template><xsl:template name="ui:msg"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="id"/>
    <xsl:apply-templates mode="ui:message" select="$id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
  </xsl:template><xsl:template name="ui:message"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="id"/>
    <xsl:apply-templates mode="ui:message" select="$id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
  </xsl:template><xsl:template match="@*|text()" mode="ui:message"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="id" select="."/>
    <xsl:variable name="file" select="//ui:messages/@href"/>
    <xsl:variable name="section" select="//ui:messages/@section"/>

    <xsl:variable name="clean-id"><xsl:apply-templates select="$id" mode="gen:strip-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:variable>
    <xsl:variable name="document" select="document( $file )"/>
    
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="string( $section ) = ''">
          <xsl:value-of select="$document//*[name() = $clean-id]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$document//*[name() = $section]/*[name() = $clean-id]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$text != ''"><xsl:value-of select="$text"/></xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($id, '{')">
            <xsl:element name="xsl:value-of">
              <xsl:attribute name="select">
                <xsl:value-of select="$clean-id"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$clean-id"/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="ui:messages"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
  </xsl:template>
  
  <xsl:template match="ui:button"><xsl:param name="address"/><xsl:param name="realaddress"/>
    <xsl:param name="node" select="."/>
    <xsl:param name="id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="context">event</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-name">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">

        <xsl:if test="@type = 'submit'">
          <script language="JavaScript">
            <xsl:text>_temis.setDefaultAction( </xsl:text>
            <xsl:apply-templates select="." mode="gen:create-event"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="event" select="'onclick'"/>
            </xsl:apply-templates>
            <xsl:text>);</xsl:text>
          </script>
        </xsl:if>


        <input id="{$control-id}" name="{$control-name}">
          
          <!-- copy attributes  -->
          <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          
          <xsl:if test="count(@type) = 0">
            <xsl:attribute name="type">button</xsl:attribute>
          </xsl:if>

          <xsl:apply-templates select="." mode="gen:test-disabling"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          <xsl:apply-templates select="." mode="button-insert-caption"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>

          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="event">onclick</xsl:with-param>
          </xsl:apply-templates>

          
          <!-- insert user code here  -->
          <xsl:apply-templates select="*"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>

        </input>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template><xsl:template match="*" mode="button-insert-caption"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
   
    <xsl:choose>
      <xsl:when test="count( @value ) !=0">
        <!-- already inserted by copier -->
      </xsl:when>

      <xsl:when test="count( @ui:caption ) !=0">
        <xsl:attribute name="value">
          <xsl:apply-templates mode="ui:message" select="@ui:caption"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
        </xsl:attribute>
      </xsl:when>

      <xsl:otherwise>
        
        <!-- use program defined text -->
        <xsl:element name="xsl:choose"><xsl:element name="xsl:when"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>text != ''</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>text</xsl:attribute></xsl:element></xsl:element></xsl:element><xsl:if test="$enable-name-as-caption='yes'">
            <xsl:call-template name="gen:newline"/><xsl:element name="xsl:when"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>name != ''</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:value-of select="$id"/><xsl:text>::</xsl:text><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>name</xsl:attribute></xsl:element></xsl:element></xsl:element>
          </xsl:if></xsl:element>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="ui:radio" match="ui:radio"><xsl:param name="address"/><xsl:param name="realaddress"/>
    <xsl:param name="node" select="."/>

    <xsl:param name="id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="context">event</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-name">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">
        <xsl:variable name="wid">
          <xsl:value-of select="$control-id"/>_<xsl:value-of select="@value"/>
        </xsl:variable>
        
        <input id="{$wid}" name="{$control-name}" type="radio">
	  <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
	    <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="event">onclick</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
	    <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="event">onchange</xsl:with-param>
          </xsl:apply-templates>

          
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:variable"><xsl:attribute name="name">value</xsl:attribute><xsl:choose>
              <xsl:when test="contains(@value, '{')">
                <xsl:attribute name="select">
                  <xsl:value-of select="substring-before( substring-after( @value, '{'), '}')"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@value"/>
              </xsl:otherwise>
            </xsl:choose></xsl:element>
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>value = $value</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">checked</xsl:attribute><xsl:text>1</xsl:text></xsl:element></xsl:element>

          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$value</xsl:attribute></xsl:element></xsl:element>
        </input>
        
        <xsl:if test="count( @ui:caption ) != 0">
          <a style="text-decoration: none; {@ui:caption-style}" class="{@ui:caption-class}" title="{@ui:caption-title}" href="javascript:void(0);">
            <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">onclick</xsl:attribute><xsl:call-template name="gen:replace-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="text">
                  <xsl:text/>javascript:_temis.clickWidget('<xsl:value-of select="$wid"/>');void(0);<xsl:text/>
                </xsl:with-param>
              </xsl:call-template></xsl:element>
            <xsl:apply-templates mode="ui:message" select="@ui:caption"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          </a>
        </xsl:if>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="ui:checkbox" match="ui:checkbox"><xsl:param name="address"/><xsl:param name="realaddress"/>
    <xsl:param name="node" select="."/>
    <xsl:param name="id"><xsl:apply-templates select="." mode="gen:sender-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    <xsl:param name="control-id"><xsl:apply-templates select="." mode="gen:control-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    <xsl:param name="control-name"><xsl:apply-templates select="." mode="gen:control-name"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">
        <input id="{$control-id}" name="{$control-name}" type="checkbox">
          <!-- copy attributes  -->
	  <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          
          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="event">onclick</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="event">onchange</xsl:with-param>
          </xsl:apply-templates>

          <xsl:variable name="checkgroup-onclick">
            <xsl:if test="count(@ui:group) !=0">
              <xsl:text/>_checkgroup.clickMember(this);<xsl:text/>
            </xsl:if>
            <xsl:if test="count(@ui:group-handler) !=0">
              <xsl:text/>_checkgroup.clickRoot(this);<xsl:text/>
            </xsl:if>
          </xsl:variable>

          <xsl:if test="$checkgroup-onclick != ''">
            <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">onclick</xsl:attribute><xsl:value-of select="$checkgroup-onclick"/></xsl:element>
          </xsl:if>
          
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:variable"><xsl:attribute name="name">value</xsl:attribute><xsl:apply-templates select="." mode="gen-selected"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="object-value" select="'checked'"/>
            </xsl:apply-templates></xsl:element>
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test">$value = '1'</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">checked</xsl:attribute><xsl:text>1</xsl:text></xsl:element></xsl:element>
          
        </input>

        <xsl:if test="count( @ui:caption ) != 0">
          <a style="text-decoration: none; {@ui:caption-style}" class="{@ui:caption-class}">
            <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">href</xsl:attribute><xsl:call-template name="gen:replace-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="text">
                  <xsl:text/>javascript:_temis.clickWidget('<xsl:value-of select="$control-id"/>');void(0);<xsl:text/>
                </xsl:with-param>
              </xsl:call-template></xsl:element>
            <xsl:apply-templates mode="ui:message" select="@ui:caption"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          </a>
        </xsl:if>

        <xsl:if test="count(@ui:group) !=0">
          <script language="javascript">
            <xsl:call-template name="gen:replace-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="text">
                <xsl:text/>_checkgroup.registerMember( '<xsl:text/>
                <xsl:value-of select="$control-id"/>', '<xsl:value-of select="@ui:group"/>');<xsl:text/>
              </xsl:with-param>
            </xsl:call-template>
          </script>
        </xsl:if>
        
        <xsl:if test="count(@ui:group-handler) !=0">
          <script language="javascript">
            <xsl:call-template name="gen:replace-braces"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="text">
                <xsl:text/>_checkgroup.registerRoot( '<xsl:text/>
                <xsl:value-of select="$control-id"/>', '<xsl:value-of select="@ui:group-handler"/>');<xsl:text/>
              </xsl:with-param>
            </xsl:call-template>
          </script>
        </xsl:if>
        
        
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="*" mode="insert-variable-for-value-of"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:call-template name="gen:newline"/><xsl:element name="xsl:variable"><xsl:attribute name="name">value</xsl:attribute><xsl:apply-templates select="." mode="gen-selected"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="object-value" select="'text'"/>
      </xsl:apply-templates><!--
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
      --></xsl:element>
   
  </xsl:template><xsl:template name="ui:textbox" match="ui:textbox"><xsl:param name="address"/><xsl:param name="realaddress"/>
    <xsl:param name="node" select="."/>

    <xsl:param name="id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="context">event</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-name">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">

        <xsl:variable name="mode">
          <xsl:choose>
            <xsl:when test="count(@ui:mode ) = 0">text</xsl:when>
            <xsl:when test="@ui:mode = 'text'">text</xsl:when>
            <xsl:when test="@ui:mode = 'multiline'">multiline</xsl:when>
            <xsl:when test="@ui:mode = 'password'">password</xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">
                <xsl:text/>Error: Invalid @ui:mode for <xsl:copy-of select="."/>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        
        <xsl:choose>
          <xsl:when test="$mode = 'multiline'">
            <textarea id="{$control-id}" name="{$control-name}">
              <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
              <!--
              <xsl:if test="count( /widget/@rows ) != 0">
                <xsl:attribute name="rows"><xsl:value-of select="@rows"/></xsl:attribute>
              </xsl:if>
              <xsl:if test="count( /widget/@cols ) != 0">
                <xsl:attribute name="cols"><xsl:value-of select="@cols"/></xsl:attribute>
              </xsl:if>
              -->

              <xsl:apply-templates select="." mode="insert-variable-for-value-of"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
              <xsl:call-template name="gen:newline"/><xsl:element name="xsl:value-of"><xsl:attribute name="select">$value</xsl:attribute></xsl:element>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <input id="{$control-id}" name="{$control-name}" type="{$mode}">
              <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
              
              <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="event">onchange</xsl:with-param>
              </xsl:apply-templates>

              <xsl:apply-templates select="." mode="insert-variable-for-value-of"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
              <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$value</xsl:attribute></xsl:element></xsl:element>
            </input>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="ui:value"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="control-id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>
    
    <xsl:param name="control-name">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>
    
    <input id="{$control-id}" name="{$control-name}" type="hidden">
      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:variable"><xsl:attribute name="name">value</xsl:attribute><xsl:choose>
          <xsl:when test="count(@value) = 0">
            <xsl:call-template name="gen:newline"/><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>value</xsl:attribute></xsl:element>
          </xsl:when>
          <xsl:when test="contains(@value, '{')">
            <xsl:attribute name="select">
              <xsl:value-of select="substring-before( substring-after( @value, '{'), '}')"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@value"/>
          </xsl:otherwise>
        </xsl:choose></xsl:element>

      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$value</xsl:attribute></xsl:element></xsl:element>
    </input>
  </xsl:template>
  <xsl:template match="ui:dropdownlist"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="id"><xsl:apply-templates select="." mode="gen:sender-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    <xsl:param name="control-id"><xsl:apply-templates select="." mode="gen:control-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    <xsl:param name="control-name"><xsl:apply-templates select="." mode="gen:control-name"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    
    <xsl:if test="count(@ui:items) != 0 and count(@ui:item-index) =0">
      TEMIS XSL Error: Element ID=
      <xsl:value-of select="@id"/>
      does not contains @ui:item-index attribute
      <br/>
    </xsl:if>
    <xsl:if test="count(@ui:items) != 0 and count(@ui:item-value) =0">
      TEMIS XSL Error: Element ID=
      <xsl:value-of select="@id"/>
      does not contains @ui:item-value attribute
      <br/>
    </xsl:if>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">
    
        <select id="{$control-id}" name="{$control-name}">
          <!-- copy attributes  -->
          <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
          
          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="event">onclick</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="event">onchange</xsl:with-param>
          </xsl:apply-templates>

          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:variable"><xsl:attribute name="name">selected</xsl:attribute><xsl:apply-templates select="." mode="gen-selected"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:element>
          <xsl:choose>
            <xsl:when test="count(@ui:items) != 0">
              <xsl:if test="count(@ui:item-index) !=0 and count(@ui:item-value) !=0">
                <!-- extern items -->
                <xsl:call-template name="gen:newline"/><xsl:element name="xsl:variable"><xsl:attribute name="name">items</xsl:attribute><xsl:attribute name="select">
                    <xsl:value-of select="substring-before( substring-after( @ui:items, '{'), '}')"/>
                  </xsl:attribute></xsl:element>
                <xsl:call-template name="gen:newline"/><xsl:element name="xsl:for-each"><xsl:attribute name="select">$items</xsl:attribute><xsl:element name="xsl:variable"><xsl:attribute name="name">itemid</xsl:attribute><xsl:attribute name="select">
                      <xsl:value-of select="substring-before( substring-after( @ui:item-index, '{'), '}')"/>
                    </xsl:attribute></xsl:element><xsl:element name="xsl:variable"><xsl:attribute name="name">itemvalue</xsl:attribute><xsl:attribute name="select">
                      <xsl:value-of select="substring-before( substring-after( @ui:item-value, '{'), '}')"/>
                    </xsl:attribute></xsl:element><option><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$itemid</xsl:attribute></xsl:element></xsl:element><xsl:element name="xsl:if"><xsl:attribute name="test">$selected = $itemid</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">selected</xsl:attribute><xsl:text>selected</xsl:text></xsl:element></xsl:element><xsl:element name="xsl:value-of"><xsl:attribute name="select">$itemvalue</xsl:attribute></xsl:element></option></xsl:element>

              </xsl:if>
            </xsl:when>
            <xsl:when test="count(child::option) = 0 and count(child::*) = 0">
              <!-- server items -->

              <xsl:call-template name="gen:newline"/><xsl:element name="xsl:for-each"><xsl:attribute name="select"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text>items/*</xsl:attribute><option><xsl:attribute name="value">{current()/@index}</xsl:attribute><xsl:element name="xsl:if"><xsl:attribute name="test">$selected = current()/@index</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">selected</xsl:attribute><xsl:text>selected</xsl:text></xsl:element></xsl:element><xsl:element name="xsl:value-of"><xsl:attribute name="select">current()/text()</xsl:attribute></xsl:element></option></xsl:element>
              
            </xsl:when>
            <xsl:when test="count(child::option) = 0 and count(child::*) != 0">
              <!-- server items -->
              <xsl:copy-of select="*"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- predefined items -->
              <xsl:for-each select="option">
                <option>
                  <xsl:copy-of select="@*"/>
                  <xsl:call-template name="gen:newline"/><xsl:element name="xsl:if"><xsl:attribute name="test"><xsl:apply-templates select="." mode="gen:object-uri"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates><xsl:text>/</xsl:text></xsl:attribute><xsl:attribute name="test">$selected = '<xsl:value-of select="@value"/>'</xsl:attribute><xsl:element name="xsl:attribute"><xsl:attribute name="name">selected</xsl:attribute><xsl:text>selected</xsl:text></xsl:element></xsl:element>
                  <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
                </option>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          
          
        </select>

      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:variable name="ajax-address" select="'/ajax'"/><xsl:template name="gen-ajax-name"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="id"/>
    <xsl:param name="context"/>

    <xsl:text>generated_</xsl:text>
    <xsl:value-of select="$context"/>
    <xsl:text>_</xsl:text>
    <xsl:call-template name="str-replace"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="search" select="'/'"/>
      <xsl:with-param name="replace" select="'_'"/>
      <xsl:with-param name="subject" select="$id"/>
    </xsl:call-template>
  </xsl:template><xsl:template match="ui:panel"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <!-- create /root/page  implementation -->
    <xsl:apply-templates select="." mode="implement-panel"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="context" select="'page'"/>
    </xsl:apply-templates>

    <!-- create /ajax/page stub -->
    <xsl:apply-templates select="." mode="gen-ajax-ref"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="context" select="'page'"/>
      <xsl:with-param name="address">
        <xsl:value-of select="$ajax-address"/>/<xsl:value-of select="@id"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template><xsl:template match="ui:panel" mode="gen-ajax-ref"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:element name="xsl:template">
      <xsl:attribute name="match">
        <xsl:value-of select="$address"/>
      </xsl:attribute>

      <xsl:element name="xsl:apply-templates">
        <xsl:attribute name="select">.</xsl:attribute>
        <xsl:attribute name="mode">
          <xsl:call-template name="gen-ajax-name"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="context" select="'page'"/>
            <xsl:with-param name="id" select="@id"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:call-template name="gen:newline"/><xsl:element name="xsl:with-param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">
            <xsl:value-of select="$address"/>
          </xsl:attribute></xsl:element>
        
        <xsl:if test="count(@ui:index) != 0">
          <xsl:call-template name="gen:newline"/><xsl:element name="xsl:with-param"><xsl:attribute name="name">ui-index</xsl:attribute><xsl:attribute name="select">
              <xsl:apply-templates select="." mode="gen:index"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="inline" select="'xpath'"/>
                <xsl:with-param name="context" select="'code'"/>
              </xsl:apply-templates>
            </xsl:attribute></xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template><xsl:template match="ui:panel" mode="implement-panel"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:param name="context"/>
    
    <xsl:param name="id"><xsl:apply-templates select="." mode="gen:sender-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    <xsl:param name="control-id"><xsl:apply-templates select="." mode="gen:control-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>
    <xsl:param name="control-name"><xsl:apply-templates select="." mode="gen:control-name"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates></xsl:param>

    <xsl:variable name="holder">
      <xsl:choose>
        <xsl:when test="count(@ui:place-holder)!=0">
          <xsl:value-of select="@ui:place-holder"/>
        </xsl:when>
        <xsl:otherwise>DIV</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:call-template name="gen:newline"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:call-template>

    <xsl:element name="xsl:template">
      <xsl:choose>
        <xsl:when test="$context = 'page'">
          <xsl:attribute name="match">*</xsl:attribute>
          <xsl:attribute name="mode">
            <xsl:call-template name="gen-ajax-name"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="context" select="$context"/>
              <xsl:with-param name="id" select="@id"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$context = 'ajax'">
          <xsl:attribute name="match">
            <xsl:value-of select="$address"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">UI Panel error: Unknown context. please choose 'page' or 'ajax'</xsl:message>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">
          <xsl:value-of select="$address"/>
        </xsl:attribute></xsl:element>
      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:param"><xsl:attribute name="name">ui-index</xsl:attribute><xsl:attribute name="select">/ajax/@index</xsl:attribute></xsl:element>

      <xsl:element name="{$holder}">
        <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
        
        <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">id</xsl:attribute><xsl:element name="xsl:text"><xsl:value-of select="$control-id"/></xsl:element><xsl:element name="xsl:if"><xsl:attribute name="test">$ui-index != ''</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">concat('-',$ui-index)</xsl:attribute></xsl:element></xsl:element></xsl:element>
        
        <xsl:apply-templates select="*|node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="address">$ui-page</xsl:with-param>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:element>
  </xsl:template><xsl:template match="xsl:template[@match='/']"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:element name="xsl:template">
      <xsl:attribute name="match">/root/page</xsl:attribute>
      <xsl:if test="@mode !=''">
        <xsl:attribute name="mode"><xsl:value-of select="@mode"/></xsl:attribute>
      </xsl:if>
	  <xsl:call-template name="gen:newline"/><xsl:element name="xsl:param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">/root/page</xsl:attribute></xsl:element>
      <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    </xsl:element>
  </xsl:template><xsl:template match="xsl:template"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:element name="xsl:template">
      <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
	  <xsl:call-template name="gen:newline"/><xsl:element name="xsl:param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">/root/page</xsl:attribute></xsl:element>
      <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    </xsl:element>
  </xsl:template><xsl:template match="xsl:apply-templates"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:element name="xsl:apply-templates">
      <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
	  <xsl:call-template name="gen:newline"/><xsl:element name="xsl:with-param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">$ui-page</xsl:attribute></xsl:element>
      <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    </xsl:element>
  </xsl:template><xsl:template match="xsl:call-template"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:element name="xsl:call-template">
      <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
	  <xsl:call-template name="gen:newline"/><xsl:element name="xsl:with-param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">$ui-page</xsl:attribute></xsl:element>
      <xsl:apply-templates select="node()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
    </xsl:element>
  </xsl:template><xsl:template match="ui:insert-panel"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:element name="xsl:apply-templates">
      <xsl:attribute name="select"><xsl:value-of select="$address"/></xsl:attribute>
      <xsl:attribute name="mode">
        <xsl:call-template name="gen-ajax-name"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="context" select="'page'"/>
          <xsl:with-param name="id" select="@id"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:call-template name="gen:newline"/><xsl:element name="xsl:with-param"><xsl:attribute name="name">ui-page</xsl:attribute><xsl:attribute name="select">
          <xsl:value-of select="$address"/>
        </xsl:attribute></xsl:element>

      <xsl:if test="count(@ui:index) != 0">
        <xsl:call-template name="gen:newline"/><xsl:element name="xsl:with-param"><xsl:attribute name="name">ui-index</xsl:attribute><xsl:attribute name="select">
            <xsl:apply-templates select="." mode="gen:index"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="inline" select="'xpath'"/>
              <xsl:with-param name="context" select="'code'"/>
            </xsl:apply-templates>
          </xsl:attribute></xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template match="ui:nbsp"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
  </xsl:template><xsl:template match="ui:space"><xsl:param name="address"/><xsl:param name="realaddress"/><xsl:param name="node"/>
    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
  </xsl:template>
  <xsl:template match="ui:visible"><xsl:param name="address"/><xsl:param name="realaddress"/>
    <xsl:param name="node" select="."/>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">
        
        <!-- insert user code here  -->
        <xsl:apply-templates select="*|text()"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="ui:file" match="ui:file"><xsl:param name="address"/><xsl:param name="realaddress"/>
    <xsl:param name="node" select="."/>

    <xsl:param name="id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="context">event</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-id">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:param name="control-name">
      <xsl:apply-templates select="." mode="gen:object-id"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

    <xsl:apply-templates select="." mode="gen:test-visibility"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="content">

            <input id="{$control-id}" name="{$control-name}" type="file">
              <xsl:apply-templates select="." mode="gen:copy-attributes"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
              
              <xsl:apply-templates select="." mode="gen:add-handler"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="event">onchange</xsl:with-param>
              </xsl:apply-templates>

              <xsl:apply-templates select="." mode="insert-variable-for-value-of"><xsl:with-param name="address" select="$address"/><xsl:with-param name="realaddress" select="$realaddress"/><xsl:with-param name="node" select="$node"/></xsl:apply-templates>
              <xsl:call-template name="gen:newline"/><xsl:element name="xsl:attribute"><xsl:attribute name="name">value</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$value</xsl:attribute></xsl:element></xsl:element>
            </input>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  
  <!-- template -->

  
</xsl:stylesheet>
