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

     This file providers templates for inserting INDEXER.
     if developer wants to use ONE handle for MANY controls of the same type.


     example:

     Developer creates some buttons according to some data,
     and wants to have only one handle all controls
     
     <xsl:for-each select="//items/*">
       <ui:button id="btnOK" ui:index="{@index}"/>
     </xsl:for-each>

     -->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  version="1.0">

  <xsl:template match="*" mode="gen:index">
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
</xsl:stylesheet>
