<?xml version="1.0"?>
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

     This is test page for testing Ui:radio properties
       
     -->
<!DOCTYPE HTML [ <!ENTITY nbsp   "&amp;nbsp;" > ]>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  exclude-result-prefixes = "ui"
  version="1.0">

  <xsl:output
    method="html"
    />

  <ui:messages href="messages.xml"/>
  <xsl:include href="../common.xsl"/>

  <xsl:template match="/">

    <html>
      <head>
        <xsl:call-template name="insert-head"/>
      </head>
      <body>
        <xsl:call-template name="insert-header"/>

        <h1>Test ui:radio</h1>

        <h2>Set value</h2>

        <h3>Simple radio button</h3>
        <p>
          
          <pre><![CDATA[<ui:radio id="radio1" value="r1"/>]]></pre>
          <ui:radio id="radio1" value="r1"/>
        </p>
        
        <h3>xpath value</h3>
        <p>
          <xsl:variable name="var">r3</xsl:variable>
          <pre><![CDATA[
<xsl:variable name="var">r3</xsl:variable>
<ui:radio id="radio1" value="{$var}"/>]]></pre>
          <ui:radio id="radio1" value="{$var}"/>
        </p>

        <h2>Set caption</h2>
        <h3>Normal caption: </h3>
        <p>
          
          <pre><![CDATA[<ui:radio id="radio1" value="r2" ui:caption="caption"/>]]></pre>
          <ui:radio id="radio1" value="r2" ui:caption="caption"/>
        </p>

        <h3>Xpath caption </h3>
        <p>
          <xsl:variable name="caption">xpath caption</xsl:variable>
          <pre><![CDATA[
<xsl:variable name="caption">xpath caption</xsl:variable>
<ui:radio id="radio1" value="r4" ui:caption="{$caption}"/>]]></pre>
          <ui:radio id="radio1" value="r4" ui:caption="{$caption}"/>
        </p>

        <h2>Actions</h2>

        <h3>On click - default on click</h3>
        <p>
          <ui:radio id="radioClick" value="click1" ui:caption="caption"/>
          <ui:radio id="radioClick" value="click2" ui:caption="caption"/>
        </p>

        <h3>On click - perform postback on click </h3>
        <p>
          
          <ui:radio id="radioClickAuto" value="click1" ui:caption="caption"/>
          <ui:radio id="radioClickAuto" value="click2" ui:caption="caption"/>
        </p>
        
        <h3>On change - default on change</h3>
        <p>
          
          <ui:radio id="radioChange" value="change1" ui:caption="caption"/>
          <ui:radio id="radioChange" value="change2" ui:caption="caption"/>
        </p>

        <h3>On change - perform postback on change </h3>
        <p>
          
          <ui:radio id="radioChangeAuto" value="change1" ui:caption="caption"/>
          <ui:radio id="radioChangeAuto" value="change2" ui:caption="caption"/>
        </p>

        <h2>Multiplicity, Indexer using</h2>
          <p>
            create radio button for each item
            <pre><![CDATA[
            <xsl:for-each select="//items/*">
              <xsl:variable name="item" select="."/>
              <xsl:for-each select="//items/*">
                <ui:radio id="radio1" ui:caption="{text()}" ui:index="item{$item/@index}" value="{@index}"/>
              </xsl:for-each>
            </xsl:for-each>
              ]]></pre>
            <table>
              <xsl:for-each select="//items/*">
                <tr>
                  <xsl:variable name="item" select="."/>
                  <xsl:for-each select="//items/*">
                    <td   style="border-bottom:thin solid black;">
                      <ui:radio id="radio1" ui:caption="{text()}" ui:index="item{$item/@index}" value="{@index}"/>
                    </td>
                  </xsl:for-each>
                </tr>
              </xsl:for-each>
            </table>
          </p>

        <h2 id="visivility">
          Visibility
        </h2>

        <table border="1" cellspacing="0">
          <tr>
            <th>Object</th>
            <th>Value setted</th>
            <th>Visible</th>
            <th>Invisible</th>
          </tr>
          <tr>
            <th>defined</th>
            <th>always</th>
            <td>
              <pre><![CDATA[ <ui:radio id="radio1" value="r100" ui:visibility="yes"/>]]></pre>
              <ui:radio id="radio1" value="r100" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:radio id="radio1" value="r102" ui:visibility="no"/>]]></pre>
              <ui:radio id="radio1" value="r102" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <th>defined</th>
            <th>by server</th>
            <td>
              <pre><![CDATA[ <ui:radio id="radioVisible" value="r103" ui:visibility="test"/>]]></pre>
              <ui:radio id="radioVisible" value="r103" ui:visibility="test"/>
            </td>
            <td>
              <pre><![CDATA[<ui:radio id="radioInvisible" value="r105" ui:visibility="test"/>]]></pre>
              <ui:radio id="radioInvisible" value="r106" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <th>defined</th>
            <th>default</th>
            <td>
              <pre><![CDATA[ <ui:radio id="radioVisible" value="r104" />]]></pre>
              <ui:radio id="radioVisible" value="r104"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:radio id="radioInvisible" value="r107" />]]></pre>
              <ui:radio id="radioInvisible" value="r108" />
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>always</th>
            <td>
              <pre><![CDATA[ <ui:radio id="UndefinedRadio" value="r101" ui:visibility="yes"/>]]></pre>
              <ui:radio id="UndefinedRadio" value="r101" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:radio id="UndefinedRadio" value="r101" ui:visibility="no"/>]]></pre>
              <ui:radio id="UndefinedRadio" value="r101" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>by server</th>
            <td>
              <pre><![CDATA[ <ui:radio id="radioUndefined" value="r103" ui:visibility="test"/>]]></pre>
              <ui:radio id="radioUndefined" value="r103" ui:visibility="test"/>
              
            </td>
            <td>
              <pre><![CDATA[<ui:radio id="radioUndefined" value="r105" ui:visibility="test"/>]]></pre>
              <ui:radio id="radioUndefined" value="r106" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>default</th>
            <td>
              <pre><![CDATA[ <ui:radio id="radioUndefined" value="r104" />]]></pre>
              <ui:radio id="radioUndefined" value="r104"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:radio id="radioUndefined" value="r107" />]]></pre>
              <ui:radio id="radioUndefined" value="r108" />
            </td>
          </tr>
        </table>
        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
