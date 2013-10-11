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
<temis:stylesheet
    xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    xmlns:gen="gen.dtd"
    xmlns:ui="ui.dtd" version="1.0">

  <temis:template match="ui:msg|ui:message" >
    <temis:apply-templates mode="ui:message" select="@id"/>
  </temis:template>

  <temis:template name="ui:msg" >
    <temis:param name="id"/>
    <temis:apply-templates mode="ui:message" select="$id"/>
  </temis:template>

  <temis:template name="ui:message">
    <temis:param name="id"/>
    <temis:apply-templates mode="ui:message" select="$id"/>
  </temis:template>

  <temis:template match="@*|text()" mode="ui:message">
    <temis:param name="id" select="."/>
    <temis:variable name="file" select="//ui:messages/@href"/>
    <temis:variable name="section" select="//ui:messages/@section"/>

    <temis:variable name="clean-id"><temis:apply-templates select="$id" mode="gen:strip-braces"/></temis:variable>
    <temis:variable name="document" select="document( $file )"/>

    <temis:variable name="text">
      <temis:choose>
        <temis:when test="string( $section ) = ''">
          <temis:value-of select="$document//*[name() = $clean-id]"/>
        </temis:when>
        <temis:otherwise>
          <temis:value-of select="$document//*[name() = $section]/*[name() = $clean-id]"/>
        </temis:otherwise>
      </temis:choose>
    </temis:variable>

    <temis:choose>
      <temis:when test="$text != ''"><temis:value-of select="$text"/></temis:when>
      <temis:otherwise>
        <temis:choose>
          <temis:when test="contains($id, '{')"><xsl:value-of select="{$clean-id}"/></temis:when>
          <temis:otherwise><temis:value-of select="$clean-id"/></temis:otherwise>
        </temis:choose>
      </temis:otherwise>
    </temis:choose>
  </temis:template>

  <temis:template match="ui:messages">
  </temis:template>
  
</temis:stylesheet>
