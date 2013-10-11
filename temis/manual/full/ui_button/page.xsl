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
      <xsl:call-template name="insert-head"/>
      <body>
        <xsl:call-template name="insert-header"/>

        <h1>Test ui:button</h1>

        <h2>Standard use case</h2>
        Standard use case: 
        <pre><![CDATA[<ui:button ]]><span class="red">id="btnOK"</span><![CDATA[ ui:caption="click me"/>]]></pre>

        <ui:button id="btnOK" ui:caption="click me"/>
        
        <h2>Caption</h2>

        <h3>Set caption directly (non-localized) </h3>
        <pre><![CDATA[ <ui:button id="btnOK" ]]><span class="red">value="caption"</span><![CDATA[/> ]]></pre>

        <ui:button id="btnOK" value="caption"/>

        <h3>Set translated caption (localized via messages.xml): </h3>
        <pre><![CDATA[ <ui:button id="btnOK" ]]><span class="red">ui:caption="caption"</span><![CDATA[/> ]]></pre>

        <ui:button id="btnOK" ui:caption="caption"/>

        <h3>Set caption from variable</h3>
        <pre><![CDATA[
<xsl:variable name="caption" select="'my caption'"/>
<ui:button id="btnOK" ]]><span class="red">ui:caption="{$caption}</span><![CDATA["/>
        ]]></pre>

        <xsl:variable name="caption" select="'my caption'"/>
        <ui:button id="btnOK" ui:caption="{$caption}"/>

        <h3>Set caption from program</h3>
        <pre><![CDATA[ <ui:button ]]><span class="red">id="btnWithCaption"</span><![CDATA[/> ]]></pre>
        <ui:button id="btnWithCaption"/>

        
        <h3>With attribute defined via XSLT instruction: </h3>
        
        <pre><![CDATA[
<ui:button id="btnOK">
  <xsl:attribute name="value">]]><span class="red">caption</span><![CDATA[</xsl:attribute>
</ui:button>]]></pre>
        <ui:button id="btnOK">
          <xsl:attribute name="value">caption</xsl:attribute>
        </ui:button>

        
        <h2>Action on click</h2>

        <h3>Simple button</h3>
        <pre><![CDATA[<ui:button id="btnOK"/>]]></pre>
        <ui:button id="btnOK"/>

        <h3>Submit button:</h3>
        <pre><![CDATA[ <ui:button id="btnOK" ]]><span class="red">type="submit"</span><![CDATA[/> ]]></pre>
        <ui:button id="btnOK" type="submit"/>

        <h3>No handles defined in object:  </h3>
        <pre><![CDATA[ <ui:button id="btnNoHandle"/>]]></pre>
        <ui:button id="btnNoHandle"/>
        
        <h3>Set target UI control for AJAX request on click:</h3>
        <pre><![CDATA[ <ui:button id="btnAjax" ]]><span class="red">ui:target="someControl"</span><![CDATA[/> ]]></pre>
        <ui:button id="btnAjax" ui:target="someControl"/>
        
        <h3>Set target window on click:</h3>
        <pre><![CDATA[ <ui:button id="buttonClick" ]]><span class="red">ui:window="somewindow"</span><![CDATA[/> ]]></pre>
        <ui:button id="buttonClick" ui:window="somewindow" ui:caption="Send event to some window"/>
        <ui:button id="buttonClick" onclick="window.open('', 'somewindow');" ui:caption="Open window"/>
        <ui:button id="btnClose" ui:caption="Close self"/>
        <ui:button id="btnClose" ui:caption="Close opened window" ui:window="somewindow"/>
          
        <h3>User defined java-script (overrides system action): </h3>
        <pre><![CDATA[ <ui:button id="btnOK" ]]><span class="red">onclick="alert('user defined java-script')"</span><![CDATA[/>]]></pre>
        <ui:button id="btnOK" onclick="alert('user defined java-script')"/>

        <h2>User defned attributes</h2>
        
        <h3>Some user HTML attributes</h3>
        <pre><![CDATA[ <ui:button id="btnOK" ]]><span class="red">style="width:200px;" class="sample"</span><![CDATA[ />]]></pre>
        <ui:button id="btnOK" style="width:200px;" class="sample"/>

        <h2>Show as Link</h2>
        <p>
          for displaying button as link, please have using CSS:
          for example style for this:
          <pre>
CSS:
            
     border:inherit;
     background:inherit;
     cursor:pointer;
     text-decoration:underline;
          </pre>
          
        </p>
        <ui:button id="btnOK" ui:mode="link" ui:caption="button showed as link" style="border:inherit;background:inherit;cursor:pointer;text-decoration:underline;padding:0;"/>

        
        <h2>Multiplicity, use indexer</h2>

        <p>
          create button for each item
          <pre><![CDATA[
<xsl:for-each select="//items/*">
  <ui:button id="btnIndexed" ui:caption="{text()}" ]]><span class="red">ui:index="{@index}</span><![CDATA["/>
</xsl:for-each>]]></pre>
          <table>
            <tr>
              <xsl:for-each select="//items/*">
                <td>
                  <ui:button id="btnIndexed" ui:caption="{text()}" ui:index="{@index}" ui:target="indexerResult"/>
                </td>
              </xsl:for-each>
            </tr>
          </table>
        </p>
        <ui:insert-panel id="indexerResult"/>
          
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
            <td>defined</td>
            <td>always</td>
            <td>
              <pre><![CDATA[
<ui:button id="btnOK"
  ui:visibility=]]><span class="red">"yes"</span><![CDATA[/>]]></pre>
              <ui:button id="btnOK" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:button id="btnOK"
  ui:visibility=]]><span class="red">"no"</span><![CDATA[/>]]></pre>
              <ui:button id="btnOK" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <td>defined</td>
            <td>by server</td>
            <td>
              <pre><![CDATA[
<ui:button id="btnOK"
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:button id="btnOK" ui:visibility="test"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:button id="btnInvisible"
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:button id="btnInvisible" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <td>defined</td>
            <td>default</td>
            <td>
              <pre><![CDATA[ <ui:button id="btnOK" />]]></pre>
              <ui:button id="btnOK"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:button id="btnInvisible" />]]></pre>
              <ui:button id="btnInvisible"/>
            </td>
          </tr>
          <tr>
            <td>undefined</td>
            <td>always</td>
            <td>
              <pre><![CDATA[
<ui:button id="UndefinedButton"
  ui:visibility=]]><span class="red">"yes"</span><![CDATA[/>]]></pre>
              <ui:button id="UndefinedButton" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:button id="UndefinedButton"
  ui:visibility=]]><span class="red">"no"</span><![CDATA[/>]]></pre>
              <ui:button id="UndefinedButton" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <td>undefined</td>
            <td>by server</td>
            <td>
              <pre><![CDATA[
<ui:button id="UndefinedButton"
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:button id="UndefinedButton" ui:visibility="test"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:button id="UndefinedButton"
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:button id="UndefinedButton" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <td>undefined</td>
            <td>default</td>
            <td>
              <pre><![CDATA[ <ui:button id="UndefinedButton" />]]></pre>
              <ui:button id="UndefinedButton"/>
            </td>
            <td>
              <pre><![CDATA[ <ui:button id="UndefinedButton" />]]></pre>
              <ui:button id="UndefinedButton" />
            </td>
          </tr>
        </table>

        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>

  <ui:panel id="indexerResult">
    <p>
      Result:<xsl:value-of select="//index"/>
  </p>
  </ui:panel>
</xsl:stylesheet>
