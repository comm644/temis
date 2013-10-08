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
  exclude-result-prefixes = "ui"
  version="1.0">

  <xsl:output method="html"/>
  <xsl:include href="../common.xsl"/>

  <xsl:template match="/">
    <html>
      <xsl:call-template name="insert-head"/>
      <body bgcolor="#FFFFFF">
        
        <h1>uiValue</h1>

        <h2>Empty value</h2>
        <pre><![CDATA[<ui:value id="valueEmpty"/>]]></pre>
        <ui:value id="valueEmpty"/>

        <h2>Loaded from server</h2>
        <pre><![CDATA[<ui:value id="valueDefined"/>]]></pre>
        <ui:value id="valueDefined"/>

        <h2>Loaded from template</h2>
        <pre><![CDATA[<ui:value id="valueEmpty" value="some value"/>]]></pre>
        <ui:value id="valueEmpty" value="some value"/>

        <h2>Indexed and loaded from template</h2>
        <pre><![CDATA[
        <xsl:for-each select="//items/*">
          <ui:value id="valueIndexed" ui:index="{@index}" value="{text()}"/>
        </xsl:for-each>
]]></pre>
        <xsl:for-each select="//items/*">
          <ui:value id="valueIndexed" ui:index="{@index}" value="{text()}"/>
        </xsl:for-each>
        
        <xsl:call-template name="insert-footer"/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
