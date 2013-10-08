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

     Templates for  generation code for inserting "address", "node", "realaddress"
     in all template calling and definiton

     this variables should have inheritances in all templates calling

     -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <!-- extensions: insert address in all calls -->
  <xsl:template match="*" mode="insert-param">
    <xsl:param name="name"/>
    
    <xsl:if test="count(*[name() ='xsl:param' and (@name=concat('/widget/',$name) or @name=$name )]) = 0">
      <xsl:element name="xsl:param">
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>


  <xsl:template match="*" mode="insert-with-param">
   <xsl:param name="name"/>
    <xsl:if test="count(*[name() ='xsl:with-param' and (@name=concat('/widget/',$name) or @name='$name' )]) = 0">
      <xsl:if test="$gen-readable = 'yes'">
        <xsl:call-template name="newline"/>
      </xsl:if>
      <xsl:element name="xsl:with-param">
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
        <xsl:attribute name="select">$<xsl:value-of select="$name"/></xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="xsl:template" >
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>
  
  <xsl:template match="xsl:template" mode="widget">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="widget"/>

      <xsl:apply-templates select="." mode="insert-param"><xsl:with-param name="name" select="'address'"/></xsl:apply-templates>
      <xsl:apply-templates select="." mode="insert-param"><xsl:with-param name="name" select="'realaddress'"/></xsl:apply-templates>
      <xsl:apply-templates select="." mode="insert-param"><xsl:with-param name="name" select="'node'"/></xsl:apply-templates>
      <xsl:apply-templates select="node()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:call-template|xsl:apply-templates" >
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>
  
  <xsl:template match="xsl:call-template|xsl:apply-templates" mode="widget">
    <xsl:if test="$gen-readable = 'yes'"><xsl:call-template name="newline"/></xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="widget"/>
      <xsl:apply-templates select="." mode="insert-with-param"><xsl:with-param name="name" select="'address'"/></xsl:apply-templates>
      <xsl:apply-templates select="." mode="insert-with-param"><xsl:with-param name="name" select="'realaddress'"/></xsl:apply-templates>
      <xsl:apply-templates select="." mode="insert-with-param"><xsl:with-param name="name" select="'node'"/></xsl:apply-templates>
      
      <xsl:if test="$gen-readable = 'yes'"><xsl:call-template name="newline"/></xsl:if>
      
      <xsl:apply-templates select="node()|text()"/>
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>
