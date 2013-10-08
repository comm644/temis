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
  version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="demo.css"/>
      </head>
      <body bgcolor="#FFFFFF" style="width:10em;padding-left:0px;">
        <b>Tests and Demos</b>
        <ul class="sidebar">
          <li><a target="main" href="empty.html">Home</a></li>
          
          <xsl:for-each select="/root/page/pages/*[not(contains(@index, 'ui'))]">
            <li><a target="main" href="{text()}"><xsl:value-of select="@index"/></a></li>
          </xsl:for-each>

          <li>
            UI Controls
            <ul>
              <xsl:for-each select="/root/page/pages/*[contains(@index, 'ui_')]">
                <li><a target="main" href="{text()}"><xsl:value-of select="@index"/></a></li>
              </xsl:for-each>
            </ul>
          </li>
          <li>
            Server objects
            <ul>
              <xsl:for-each select="/root/page/pages/*[contains(@index, 'uiPage_')]">
                <li><a target="main" href="{text()}"><xsl:value-of select="@index"/></a></li>
              </xsl:for-each>
            </ul>
          </li>
        </ul>

        <ui:button id="btnReset" ui:caption="Reset internals" ui:target="empty"/>
        <ui:insert-panel id="empty"/>
      </body>
    </html>
  </xsl:template>

  <ui:panel id="empty">
  </ui:panel>

</xsl:stylesheet>
