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

     This file contains templates swticinh and translating OBJECT instructions
     
     -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xitec="xitec.dtd"
                version="1.0">

  <xsl:output method="xml"/>

  <!-- Element generator

       Generates instructions for creating intructions
       -->

  <!-- switch to gen -->
  <xsl:template match="node()[
                       contains(name(),'xsl:')
                       and ( contains( @test,'/object/')
                       or contains( @name,'/object/')
                       or contains( @match,'/object/')
                       or contains( @select,'/object/') )]">
    <xsl:if test="$result-readable = 'yes'">
      <xsl:copy-of select="document('macros.xsl')//xsl:template[@name='newline']/*"/>
    </xsl:if>
    <xsl:apply-templates select="." mode="gen"/>
  </xsl:template>

  <xsl:template match="node()[not(contains(name(),'xsl:'))
                       and contains(@*,'/object/')]">
    <xsl:apply-templates select="." mode="gen"/>
  </xsl:template>

  <xsl:template match="xsl:choose[contains( child::xsl:when/@test,'/object/')]">
    <xsl:apply-templates select="." mode="gen"/>
  </xsl:template>

  <!-- switch from WIDGET to GEN -->
  <xsl:template mode="widget" match="*[contains(name(),'xsl:')
                       and ( contains( @test,'/object/')
                       or contains( @name,'/object/')
                       or contains( @match,'/object/')
                       or contains( @select,'/object/') )]">
    <xsl:apply-templates select="." mode="gen"/>
  </xsl:template>
  
  <!-- generators -->
  
  <xsl:template match="xsl:template" mode="gen">
    <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="gen"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:template[contains(@match,'/object')]" mode="gen">
    <xsl:call-template name="gen-node">
      <xsl:with-param name="node" select="."/>
      </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template match="text()" mode="gen">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="@*|node()" mode="gen-strip">
    <xsl:call-template name="str-replace">
      <xsl:with-param name="search">/object/</xsl:with-param>
      <xsl:with-param name="replace"></xsl:with-param>
      <xsl:with-param name="subject" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="node()" mode="gen-clean">
    <xsl:copy>
      <xsl:attribute name="name">
        <xsl:apply-templates select="@name" mode="gen-strip"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" mode="gen"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xsl:element[contains( @name,'/object/')]" mode="gen">
    <xsl:apply-templates select="." mode="gen-clean"/>
  </xsl:template>
  <xsl:template match="xsl:with-param[contains( @name,'/object/')]" mode="gen">
    <xsl:apply-templates select="." mode="gen-half"/>
  </xsl:template>
  <xsl:template match="xsl:call-template[contains( @name,'/object/')]" mode="gen">
    <xsl:apply-templates select="." mode="gen-half"/>
  </xsl:template>
  <xsl:template match="xsl:param[contains( @name,'/object/')]" mode="gen">
    <xsl:apply-templates select="." mode="gen-half"/>
  </xsl:template>
  <xsl:template match="xsl:attribute[contains( @name,'/object/')]" mode="gen">
     <xsl:apply-templates select="." mode="gen-half"/>
  </xsl:template>
  <xsl:template match="xsl:variable[contains( @name,'/object/')]" mode="gen">
    <xsl:apply-templates select="." mode="gen-half"/>
  </xsl:template>

  <xsl:template match="xsl:attribute" mode="gen">
    <xsl:apply-templates select="." mode="gen-half"/>
  </xsl:template>

  
  
  <xsl:template match="node()" mode="gen" name="gen-node">
    <xsl:param name="node" select="."/>
    
    <xsl:if test="$gen-readable = 'yes'">
      <xsl:call-template name="newline"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="starts-with(name($node),'xsl:')">
        <xsl:if test="$gen-readable = 'yes'"><xsl:call-template name="newline"/></xsl:if>
        <xsl:element name="xsl:element">
          <xsl:attribute name="name"><xsl:value-of select="name($node)"/></xsl:attribute>
          <xsl:apply-templates select="$node/@*|$node/node()" mode="gen"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$node">
          <xsl:copy>
            <xsl:apply-templates select="$node/@*|$node/node()" mode="gen"/>
          </xsl:copy>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()" mode="gen">
    <xsl:if test="normalize-space(.)!=''">
      <xsl:element name="xsl:text">
        <xsl:copy-of select="."/>
        <xsl:apply-templates select="node()|text()" mode="widget"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*" mode="gen">
    <xsl:if test="$gen-readable = 'yes'">
      <xsl:call-template name="newline"/>
    </xsl:if>
    <xsl:element name="xsl:attribute">
      <xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
      <xsl:variable name="uri">
        <xsl:apply-templates select="document('macros.xsl')//xsl:template[@name='object-uri']/*" mode="widget"/>
      </xsl:variable>
      <xsl:variable name="tag" select="'/object/'"/>
      
      <xsl:choose>
        <!-- filter using variables -->
        <xsl:when test="(name()='test' or name()='select') and ( contains(.,$tag))">
          <xsl:variable name="unvar">
            <xsl:call-template name="str-replace">
              <xsl:with-param name="search"><xsl:value-of select="$tag"/>$</xsl:with-param>
              <xsl:with-param name="replace" select="'$'"/>
              <xsl:with-param name="subject" select="."/>
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:call-template name="str-replace">
            <xsl:with-param name="search" select="$tag"/>
            <xsl:with-param name="replace" select="$uri"/>
            <xsl:with-param name="subject" select="$unvar"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains(.,'text()') or contains(.,'position()') or contains(.,'current()')">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="not(contains(.,'/object'))">
          <xsl:value-of select="$uri"/>
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="not(starts-with(.,'/object/$'))">
          <!-- contains but not started-with -->
          <!-- insert real address of item -->
          <xsl:call-template name="str-replace">
            <xsl:with-param name="search" select="$tag"/>
            <xsl:with-param name="replace" select="$uri"/>
            <xsl:with-param name="subject" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- remove -->
          <xsl:call-template name="str-replace">
            <xsl:with-param name="search" select="$tag"/>
            <xsl:with-param name="replace"/>
            <xsl:with-param name="subject" select="."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      
      <!--
      <xsl:apply-templates select="@*|node()|text()" mode="gen"/>
      -->
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*" mode="gen-half">
    <xsl:if test="$gen-readable = 'yes'">
      <xsl:call-template name="newline"/>
    </xsl:if>
    
    <xsl:element name="xsl:attribute">
      <xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>

      <xsl:call-template name="str-replace">
        <xsl:with-param name="search">/object/</xsl:with-param>
        <!-- insert real address of item -->
        <xsl:with-param name="replace"/>
        <xsl:with-param name="subject" select="."/>
      </xsl:call-template>

      <!--
      <xsl:apply-templates select="@*|node()|text()" mode="gen"/>
      -->
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="node()" mode="gen-half">
    <xsl:choose>
      <xsl:when test="starts-with(name(),'xsl:')">
        <xsl:element name="xsl:element">
          <xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
          <xsl:apply-templates select="@name" mode="gen-half"/>
          <xsl:apply-templates select="@*[name()!='name']|node()" mode="gen"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="gen"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
