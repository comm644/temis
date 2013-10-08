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


  <xsl:include href="../common.xsl"/>
  
  
  <xsl:template match="/">

    <html>
      <xsl:call-template name="insert-head"/>
      <body>
        <xsl:call-template name="insert-header"/>

        <h1>Test ui:visible</h1>

        <h2>Description</h2>
        <p>
          Visibility block provide service for checking visibily of some ui object and
          insert or not insert internal block.

          Usually can be user for generating menu items, because if you want to create
          menu based on CSS wuth using list items your have need write the code:
        </p>
        <pre><![CDATA[
        <li>
          <ui:button id="miSomeItem" ui:caption="some menu item"/>
        </li>]]></pre>
        
        <p>
          now if you would like to hide this item phisically (do not say anything about this item to user)
          then you need to remove all items which have arrounding button.
          <br/>
          
          For geetting this feature need to use this UI element:
        </p>
        
        <pre><![CDATA[
        <ui:visible id="miSomeItem">
          <li>
            <ui:button id="miSomeItem" ui:caption="some menu item"/>
          </li>
        </ui:visible>]]></pre>

        
        
        <h2 id="visivility">
          Visibility
        </h2>

        <table border="1" cellspacing="0"  width="400pt" style="empty-cells:show;">
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
  <ui:visible id="btnVisible"
    ui:visibility="yes">
    some content
  </ui:visible>]]></pre>
  
              <ui:visible id="btnVisible" ui:visibility="yes">
                some content
                <ui:button id="btnVisible" ui:visibility="yes" ui:caption="click me"/>
              </ui:visible>
            </td>
            <td>
              <pre><![CDATA[
  <ui:visible id="btnVisible"
    ui:visibility="no">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="btnInvisible" ui:visibility="no">
                some content
                <ui:button id="btnInvisible" ui:visibility="no"/>
              </ui:visible>
            </td>
          </tr>
          <tr>
            <td>defined</td>
            <td>by server</td>
            <td>
              <pre><![CDATA[
  <ui:visible id="btnVisible"
    ui:visibility="test">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="btnVisible" ui:visibility="test">
                some content
                <ui:button id="btnVisible" ui:visibility="test" ui:caption="click me"/>
              </ui:visible>
            </td>
            <td>
              <ui:visible id="btnInvisible" ui:visibility="test">
                some content
                <ui:button id="btnInvisible" ui:visibility="test"/>
              </ui:visible>
            </td>
          </tr>
          <tr>
            <td>defined</td>
            <td>default</td>
            <td>
              <pre><![CDATA[
  <ui:visible id="btnVisible">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="btnVisible">
                some content
                <ui:button id="btnVisible" ui:caption="click me"/>
              </ui:visible>
            </td>
            <td>
              <ui:visible id="btnInvisible">
                some content
                <ui:button id="btnInvisible"/>
              </ui:visible>
            </td>
          </tr>
          <tr>
            <td>undefined</td>
            <td>always</td>
            <td>
              <pre><![CDATA[
  <ui:visible id="UndefinedButton"
    ui:visibility="yes">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="UndefinedButton" ui:visibility="yes">
                some content
                <ui:button id="UndefinedButton" ui:visibility="yes"/>
              </ui:visible>
            </td>
            <td>
              <pre><![CDATA[
  <ui:visible id="UndefinedButton"
    ui:visibility="yes">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="UndefinedButton" ui:visibility="no">
                some content
                <ui:button id="UndefinedButton" ui:visibility="no"/>
              </ui:visible>
            </td>
          </tr>
          <tr>
            <td>undefined</td>
            <td>by server</td>
            <td>
              <pre><![CDATA[
  <ui:visible id="UndefinedButton"
    ui:visibility="test">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="UndefinedButton" ui:visibility="test">
                some content
                <ui:button id="UndefinedButton" ui:visibility="test"/>
              </ui:visible>

              <ui:button id="UndefinedButton" ui:visibility="test"/>
            </td>
            <td>
              <ui:visible id="UndefinedButton" ui:visibility="test">
                some content
                <ui:button id="UndefinedButton" ui:visibility="test"/>
              </ui:visible>
            </td>
          </tr>
          <tr>
            <td>undefined</td>
            <td>default</td>
            <td>
              <pre><![CDATA[
 <ui:visible id="UndefinedButton">
    some content
  </ui:visible>]]></pre>
              <ui:visible id="UndefinedButton" >
                some content
                <ui:button id="UndefinedButton"/>
              </ui:visible>

              <ui:button id="UndefinedButton" />
            </td>
            <td>
              <ui:visible id="UndefinedButton">
                some content
                <ui:button id="UndefinedButton"/>
              </ui:visible>
            </td>
          </tr>
        </table>

        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
