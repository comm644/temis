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
  exclude-result-prefixes="ui gen"
  version="1.0">

  <!-- UI Multiselect generator -->

  <xsl:template match="ui:multiselect">
    <xsl:param name="__address"/>
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="__address" select="$__address"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates select="." mode="gen:test-visibility">
      <xsl:with-param name="__address" select="$__address"/>
      <xsl:with-param name="content">
        
        <script>
          <xsl:text>__multiselect.register( '</xsl:text><xsl:value-of select="$id"/><xsl:text>' );</xsl:text>
        </script>

        <input type="hidden" name="{$id}"/>
        <select id="{$id}_widget" name="{$id}_widget" multiple="1">
          <xsl:apply-templates select="." mode="gen:init-object">
            <xsl:with-param name="__address" select="$__address"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="gen:add-handler">
            <xsl:with-param name="event">onchange</xsl:with-param>
          </xsl:apply-templates>
          
          
          <xsl:choose>
            <xsl:when test="count( child::option ) != 0">
              <!-- copy template defined items -->
              <xsl:for-each select="./child::option">
                <xsl:copy-of select="."/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="items">
                <xsl:choose>
                  <xsl:when test="@ui:items"><xsl:value-of select="@ui:items"/></xsl:when>
                  <xsl:otherwise>$object/items/*</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <xsl:call-template name="gen:for-each">
                <xsl:with-param name="select"><xsl:value-of select="$items"/></xsl:with-param>
                <xsl:with-param name="content">
                  <xsl:call-template name="gen:option">
                    <xsl:with-param name="field" select="@ui:field"/>
                    <xsl:with-param name="index" select="@ui:index"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          


        </select>

      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


</xsl:stylesheet>
