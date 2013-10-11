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
<!DOCTYPE HTML SYSTEM "html40_entities.dtd">
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  
                version="1.0">

  <xsl:output method="html"/>
  <xsl:include href="../common.xsl"/>

  <xsl:template match="/">
    <html>
      <xsl:call-template name="insert-head"/>
      <body bgcolor="#FFFFFF">
        <xsl:call-template name="insert-header"/>
        <h1>Test nbsp</h1>

        <h2>Using xsl:text - does not work.</h2>
        <div>
          <pre><![CDATA[text|<xsl:text disable-output-escaping="yes">]]><span class="red"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]></span><![CDATA[</xsl:text>|text]]></pre>
          <pre>
          <xsl:text>text|</xsl:text>
          <xsl:text disable-output-escaping="yes">&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
          <xsl:text>|text</xsl:text>
          </pre>
        </div>

        <h2>Using direct inserting - does not work.</h2>
        <pre><![CDATA[text|]]><span class="red"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]></span><![CDATA[|text]]></pre>
        <div>
          text|
          &nbsp;&nbsp;&nbsp;&nbsp;
          |text
        </div>

        <h2>Using ui:nbsp - works</h2>

        <pre><![CDATA[text|]]><span class="red"><![CDATA[<ui:nbsp/>]]></span><![CDATA[<ui:nbsp/><ui:nbsp/><ui:nbsp/>|text]]></pre>
        <div>

          text|<ui:nbsp/><ui:nbsp/><ui:nbsp/><ui:nbsp/>|text
        </div>

        <h2>Using ui:space - works</h2>
        <pre>
          <![CDATA[text&lt;]]><span class="red"><![CDATA[<ui:space/>]]></span><![CDATA[<ui:space/><ui:space/><ui:space/>&gt;text]]>
        </pre>
        text|<ui:space/><ui:space/><ui:space/><ui:space/>|text

        <h2>Using &amp;#160 - works</h2>
        <pre>
          <![CDATA[text|&#160;&#160;&#160;&#160;|text]]>
        </pre>

        <div>
          text|&#160;&#160;&#160;&#160;|text
        </div>
		
        <xsl:call-template name="insert-footer"/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
