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

<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  version="1.0">

  <temis:template match="*" mode="gen-index">
    <temis:param name="index" select="@ui:index"/>
    <temis:param name="inline"/>
    <temis:param name="context">name</temis:param>

    <temis:if test="$index!=''">
      
      <temis:variable name="code">
        <temis:choose>
          <temis:when test="$inline='yes'">
            <temis:value-of select="$index"/>
          </temis:when>

          <temis:when test="$inline = 'xpath' and starts-with( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
          </temis:when>

          <temis:when test="$inline='xpath' and contains( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            
            <temis:text>concat('</temis:text>
            <temis:value-of select="substring-before( $index, '{')"/>
            <temis:text>',</temis:text>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
            <temis:text>)</temis:text>
          </temis:when>
          <temis:when test="$inline='xpath'">
            <temis:value-of select="$index"/>
          </temis:when>
          <temis:otherwise>
            <temis:value-of select="$index"/>
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <xsl:value-of select="{$codeline}"/>

          </temis:otherwise>
        </temis:choose>
      </temis:variable>

      <temis:choose>
        <temis:when test="$context='id'">
          <!--  <input id="id$id"/> -->
          <temis:text>--</temis:text><temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='name'">
          <!--  <input name="id[index]"/> -->
          <temis:text>[</temis:text><temis:copy-of select="$code"/> <temis:text>]</temis:text>
        </temis:when>
        <temis:when test="$context='noindex'"/>
        <temis:when test="$context='event'">
          <!--
               js:  cation="event:" + id + ":" + event;

               event:object$object$object:onclick       - without index
               event:object$object$object-index:onclick - with index
               -->
          <temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='xpath' and contains( $index, '{')">
          <temis:text/>/*[ @index = <temis:copy-of select="$code"/>]<temis:text/>
        </temis:when>
        <temis:when test="$context='xpath' ">
          <temis:text/>/*[ @index = '<temis:copy-of select="$code"/>']<temis:text/>
        </temis:when>
        <temis:when test="$context='code' ">
          <temis:copy-of select="$code"/>
        </temis:when>
      </temis:choose>
    </temis:if>
    
  </temis:template>


  <temis:template match="*" mode="gen-index-name">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>[<temis:value-of select="@ui:index"/>]<temis:text/>
    </temis:if>
  </temis:template>

  <temis:template match="*" mode="gen-index-id">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>-<temis:value-of select="@ui:index"/>
    </temis:if>
  </temis:template>

  <temis:template match="*" mode="gen-index-xpath">
    <temis:apply-templates select="." mode="gen-index">
      <temis:with-param name="inline" select="'xpath'"/>
      <temis:with-param name="context" select="'xpath'"/>
    </temis:apply-templates>
  </temis:template>

  <temis:template match="*|@*|text()" mode="gen-index-valueof">
    <temis:param name="index" select="."/>
    <temis:choose>
      <temis:when test="contains($index,'{')">
        <xsl:value-of>
          <temis:attribute name="select">
            <temis:value-of select="substring-before( substring-after(  $index, '{' ), '}')"/>
          </temis:attribute>
        </xsl:value-of>
      </temis:when>
      <temis:otherwise>
        <temis:value-of select="$index"/>
      </temis:otherwise>
    </temis:choose>
  </temis:template>


</temis:stylesheet>
