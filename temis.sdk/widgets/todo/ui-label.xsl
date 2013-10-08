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

  <!-- UI label  generator -->
  <xsl:template match="ui:label">
    <xsl:param name="__address"/>
    
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="__address" select="$__address"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates select="." mode="gen:test-visibility">
      <xsl:with-param name="__address" select="$__address"/>
      <xsl:with-param name="content">
        
        <span id="{$id}">
          <xsl:apply-templates select="." mode="gen:init-object">
            <xsl:with-param name="__address" select="$__address"/>
          </xsl:apply-templates>
          <xsl:call-template name="gen:value-of">
            <xsl:with-param name="select">$object/text</xsl:with-param>
          </xsl:call-template>
        </span>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
