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

     This is test page for testing Ui:textbox properties
       
     -->
<!DOCTYPE HTML [ <!ENTITY nbsp   "&amp;nbsp;" > ]>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  exclude-result-prefixes = "ui"
  version="1.0">

  <xsl:output
    method="xml"
    />

  <xsl:include href="../common.xsl"/>
  
  <xsl:template match="/">

    <html>
      <xsl:call-template name="insert-head"/>
      <body >
      <xsl:call-template name="insert-header"/>
      
        <h1>Test ui:textbox</h1>

        <h1>Simple Textbox</h1>

        <h2>Set value</h2>

        <p>
          Simple widget (server value )
          
          <pre><![CDATA[<ui:textbox id="textbox1"/>]]></pre>
          <ui:textbox id="textbox1"/>
        </p>

        <p>
          Predefined value

          <pre><![CDATA[<ui:textbox id="textbox1" value="some text"/>]]></pre>
          <ui:textbox id="textbox1" value="some text"/>
        </p>

        <p>
          <xsl:variable name="var">some text</xsl:variable>
          <th>Xpath value</th>

          <pre><![CDATA[<xsl:variable name="var">some text</xsl:variable>
<ui:textbox id="textbox1" value="{$var}"/>]]></pre>
          <ui:textbox id="textbox1" value="{$var}"/>
        </p>

        <h1>Password textbox</h1>

        <h2>Set value</h2>
        <p>
          Simple widget (server value )
          
          <pre><![CDATA[<ui:textbox id="textbox1" ui:mode="password"/>]]></pre>
          <ui:textbox id="textbox1" ui:mode="password"/>
        </p>

        <p>
          Predefined value

          <pre><![CDATA[<ui:textbox id="textbox1" mode="password" value="some text"/>]]></pre>
<ui:textbox id="textbox1" ui:mode="password" value="some text"/>
        </p>

        <p>
          <xsl:variable name="var">some text</xsl:variable>
          <th>Xpath value</th>

          <pre><![CDATA[<xsl:variable name="var">some text</xsl:variable>
          <xsl:text/><ui:textbox id="textbox1" ui:mode="password" value="{$var}"/>]]></pre>
          <ui:textbox id="textbox1" ui:mode="password" value="{$var}"/>
        </p>
        

        <h1>Multiline textbox </h1>
        
        <h2>Set value</h2>

        <p>
          Simple widget (server value )
          
          <pre><![CDATA[<ui:textbox id="textbox1" ui:mode="multiline"/>]]></pre>
          <ui:textbox id="textbox1" ui:mode="multiline"/>
        </p>

        <p>
          Predefined value

          <pre><![CDATA[<ui:textbox id="textbox1" ui:mode="multiline" value="some text"/>]]></pre>
          <ui:textbox id="textbox1" ui:mode="multiline" value="some text"/>
        </p>

        <p>
          <xsl:variable name="var">some text</xsl:variable>
          <th>Xpath value</th>

          <pre><![CDATA[<xsl:variable name="var">some text</xsl:variable>
<ui:textbox id="textbox1" ui:mode="multiline" value="{$var}"/>]]></pre>
          <ui:textbox id="textbox1" ui:mode="multiline" value="{$var}"/>
        </p>


        <h2>Actions</h2>

        <h3>On change</h3>
        <p>
          default on change
          <ui:textbox id="textbox1" />
        </p>
        <p>
          perform postback on change
          <ui:textbox id="textboxChangeAuto" />
        </p>
        <p>
          WHEN ui:index defined as text THEN event must be indexed.
          <ui:textbox id="textboxChangeAuto" ui:index="item1"/>
        </p>
        <p>
          WHEN ui:index defined as {$var} THEN event must be indexed by variable.
          <xsl:variable name="var" select="'index'"/>
          <ui:textbox id="textboxChangeAuto" ui:index="{$var}"/>
        </p>
        <p>
          Event Targeting ui:target
          <ui:textbox id="textboxChangeAuto" ui:target="panel"/>
        </p>
        <p>
          Event Window Targeting ui:target
          <ui:textbox id="textboxChangeAuto" ui:target-window="new"/>
        </p>
        <p>
          Event Window Targeting ui:target-index
          <ui:textbox id="textboxChangeAuto" ui:target="panel"  ui:target-index="item1"/>
        </p>
        <p>
          Event Window Targeting calculated ui:target-index
          <xsl:variable name="var" select="'index'"/>
          <ui:textbox id="textboxChangeAuto" ui:target="panel"  ui:target-index="{$var}"/>
        </p>
        <p>
          WHEN user defined self own onchange JS handler THEN server handling must be ignored
          <ui:textbox id="textboxChangeAuto" onchange="alert('ok')"/>
        </p>

        <h2>User defined attrbiutes</h2>
        <p>
          You can to add additional HTML attribues to generated element
        </p>
        <pre><![CDATA[
        <ui:textbox id="textbox1" style="width:200px;background-color:yellow;"/><br/>
        <ui:textbox id="textbox1" style="width:200px;background-color:yellow;" ui:mode="multiline"/>
        ]]></pre>

        <ui:textbox id="textbox1" style="width:200px;background-color:yellow;"/><br/>
        <ui:textbox id="textbox1" style="width:200px;background-color:yellow;" ui:mode="multiline"/>


        <h2>Multiplicity, Indexer using</h2>
        <h3>Predefined extenal items + selected by server  </h3>
        <p>
          create textbox for each item
          <pre><![CDATA[
            <xsl:for-each select="//items/*">
              <ui:textbox id="textboxIndexer" ui:index="item{@index}" value="{text()}"/>
            </xsl:for-each>
              ]]></pre>
          <xsl:for-each select="//items/*">
            <ui:textbox id="textboxIndexer" ui:index="item{@index}" value="{text()}"/>
          </xsl:for-each>
        </p>

        <h3>Loaded from server</h3>
        <p>
          <pre><![CDATA[
          <ui:textbox id="textboxIndexer" ui:index="item1"/>
          <ui:textbox id="textboxIndexer" ui:index="item2"/>
          <ui:textbox id="textboxIndexer" ui:index="item3"/>]]></pre>

          <ui:textbox id="textboxIndexer" ui:index="item1"/>
          <ui:textbox id="textboxIndexer" ui:index="item2"/>
          <ui:textbox id="textboxIndexer" ui:index="item3"/>
        </p>

        <h3>Generated by some source  </h3>
        <pre><![CDATA[
        <xsl:for-each select="//items/*">
          <ui:textbox id="textboxIndexer" ui:index="item{@index}"/>
        </xsl:for-each>]]></pre>
        <xsl:for-each select="//items/*">
          <ui:textbox id="textboxIndexer" ui:index="item{@index}"/>
        </xsl:for-each>

        <h1 id="visivility">
          Visibility
        </h1>

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
              <pre><![CDATA[ <ui:textbox id="textbox1" value="r100" ui:visibility="yes"/>]]></pre>
              <ui:textbox id="textbox1" value="r100" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:textbox id="textbox1" value="r102" ui:visibility="no"/>]]></pre>
              <ui:textbox id="textbox1" value="r102" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <th>defined</th>
            <th>by server</th>
            <td>
              <pre><![CDATA[ <ui:textbox id="textboxVisible" value="r103" ui:visibility="test"/>]]></pre>
              <ui:textbox id="textboxVisible" value="r103" ui:visibility="test"/>
            </td>
            <td>
              <pre><![CDATA[<ui:textbox id="textboxInvisible" value="r105" ui:visibility="test"/>]]></pre>
              <ui:textbox id="textboxInvisible" value="r106" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <th>defined</th>
            <th>default</th>
            <td>
              <pre><![CDATA[ <ui:textbox id="textboxVisible" value="r104" />]]></pre>
              <ui:textbox id="textboxVisible" value="r104"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:textbox id="textboxInvisible" value="r107" />]]></pre>
              <ui:textbox id="textboxInvisible" value="r108" />
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>always</th>
            <td>
              <pre><![CDATA[ <ui:textbox id="UndefinedTextbox" value="r101" ui:visibility="yes"/>]]></pre>
              <ui:textbox id="UndefinedTextbox" value="r101" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:textbox id="UndefinedTextbox" value="r101" ui:visibility="no"/>]]></pre>
              <ui:textbox id="UndefinedTextbox" value="r101" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>by server</th>
            <td>
              <pre><![CDATA[ <ui:textbox id="textboxUndefined" value="r103" ui:visibility="test"/>]]></pre>
              <ui:textbox id="textboxUndefined" value="r103" ui:visibility="test"/>
              
            </td>
            <td>
              <pre><![CDATA[<ui:textbox id="textboxUndefined" value="r105" ui:visibility="test"/>]]></pre>
              <ui:textbox id="textboxUndefined" value="r106" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>default</th>
            <td>
              <pre><![CDATA[ <ui:textbox id="textboxUndefined" value="r104" />]]></pre>
              <ui:textbox id="textboxUndefined" value="r104"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:textbox id="textboxUndefined" value="r107" />]]></pre>
              <ui:textbox id="textboxUndefined" value="r108" />
            </td>
          </tr>
        </table>

        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
