<?xml version="1.0" encoding="cp1251"?>
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
  exclude-result-prefixes="ui"

  version="1.0">

  <xsl:output method="html"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    />

  <xsl:include href="page2.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Quick Reference</title>
        <style>
          code { font-size: 12px; font-weight: bold; }
        </style>
      </head>
      <body bgcolor="#FFFFFF">

          <table border="1" cellpadding="5" cellspacing="0" width="100%">
            <tr>
              <th colspan="3">
                <h1>Widgets: Quick Reference</h1>
                <center>for details see <a href="../full">Developer manual pages</a></center>
              </th>
            </tr>
            <tr style="background-color: #90ECEC;">
              <th width="150px">Widget Name</th>
              <th>Sample</th>
              <th>How to get</th>
            </tr>
            <tr>
              <td>ui:button</td>
              <td>
                <ui:button id="btnOK" style="width: 200px" value="Button1" type="submit"/>
              </td>
              <td>
                <code>
                  <![CDATA[ <ui:button id="[id]" value="[caption]" type="submit"/>]]><br/>
                  or <![CDATA[ <ui:button id="[id]" value="[caption]" />]]><br/>
                  or <![CDATA[ <ui:button id="[id]" />]]><br/>
                </code>
              </td>
            </tr>
            <tr>
              <td>
                ui:radio
              </td>
              <td>
                <ui:radio id="rbRadioButton" value="0"/>
                <ui:radio id="rbRadioButton" value="1"/>
                <ui:radio id="rbRadioButton" value="2"/>
              </td>
              <td>
                <code>
                  <![CDATA[<ui:radio id="[id]" value="[assigned-value]"/>]]>
                </code>
              </td>
            </tr>
            <tr>
              <td>
                ui:checkbox
              </td>
              <td>
                <ui:checkbox id="cbCheckBox"/>
              </td>
              <td>
                <code>
                  <![CDATA[<ui:checkbox id="[id]"/>]]>
                </code>
              </td>
            </tr>
            <tr>
              <td>
                ui:textbox
              </td>
              <td>
                <table width="100%">
                  <tr>
                    <td><ui:textbox id="tbText"/></td>
                    <td rowspan="2"><ui:textbox id="tbText" ui:mode="multiline" rows="3"/></td>
                  </tr>
                  <tr>
                    <td><ui:textbox id="tbText" ui:mode="password"/></td>
                  </tr>
                </table>
              </td>
              <td>
                <code>
                  <![CDATA[<ui:textbox id="[name]"/>]]><br/>
                  <![CDATA[<ui:textbox id="[name]" ui:mode="password"/>]]><br/>
                  <![CDATA[<ui:textbox id="[name]" ui:mode="multiline" rows="3"/>]]><br/>
                </code>
              
              </td>
            </tr>

            <tr>
              <td >
                ui:dropdownlist
              </td>
              <td>
                <ui:dropdownlist id="dropdown" style="width: 200px;"/>
              </td>
              <td>
                <code>
                  <![CDATA[<ui:dropdownlist id="[id]" />]]>
                </code>
              </td>
            </tr>

            <tr>
              <td>ui:multiselect</td>
              <td>
                <ui:multiselect id="multiselect" style="width: 200px;"  size="3"/>
              </td>
              <td>
                <code><pre style="margin:0;"><![CDATA[
<ui:multiselect id="[name]" style="width: 200px;" size="2"/>
]]></pre></code>
              </td>
            </tr>
            
            <tr>
              <td>ui:checkbox</td>
              <td>
                <ui:checkbox id="multicheck" ui:group-handler="gr" ui:index="root"/>
                <ui:checkbox id="multicheck" ui:group="gr" ui:index="0"/>
                <ui:checkbox id="multicheck" ui:group="gr" ui:index="1"/>
                <ui:checkbox id="multicheck" ui:group="gr" ui:index="2"/>
              </td>
              <td>
                <code><pre style="margin:0;"><![CDATA[
<ui:checkbox id="multicheck" ui:group-handler="gr" ui:index="root"/>
<ui:checkbox id="multicheck" ui:group="gr" ui:index="0"/>
<ui:checkbox id="multicheck" ui:group="gr" ui:index="1"/>
<ui:checkbox id="multicheck" ui:group="gr" ui:index="2"/>
]]></pre></code>

              </td>
            </tr>

            <!-- ///////////////////////////////////////////////////////////////////////////////////////// -->
            <tr style="background-color: #90ECEC;">
              <th colspan="3" >Customize DropDownList </th>
            </tr>
            
            <tr>
              <td >
                ui:dropdownlist
              </td>
              <td>
                <ui:dropdownlist id="dropdown" name="dd2" style="width: 200px;"
                  ui:items="{//data/*}"
                  ui:item-index="{@index}"
                  ui:item-value="{text()}"
                  />
              </td>
              <td>
                name=dd2: use binding to other resource for NAME
                <br/>
                <code>&lt;ui:dropdownlist id="[name]" name="[uiname]"
                <div style="padding-left: 50px">
                  ui:items="//data/*"/&gt;
                </div>
                </code>
              </td>
            </tr>
            <tr>
              <td >
                ui:dropdownlist
              </td>
              <td>
                <ui:dropdownlist id="dropdown" name="dd3" style="width: 200px;"
                  ui:items="{//data/*}" ui:item-index="{@index}" ui:item-value="{text()}"/>
              </td>
              <td>
                use binding INDEXES for VALUE and NAME
                <br/>
                <code>&lt;ui:dropdownlist id="[name]" name="[uiname]"
                <div style="padding-left: 50px">
                  ui:items="//data/*" ui:field="@index"/&gt;
                </div>
                </code>
              </td>
            </tr>
            <tr>
              <td >
                ui:dropdownlist
              </td>
              <td>
                <ui:dropdownlist id="dropdown" name="dd4" style="width: 200px;"
                  ui:items="{//data/*}"
                  ui:item-index="{@index}"
                  ui:item-value="{text()}"/>
              </td>
              <td>
                use reverse binding for NAME and VALUE
                <br/>
                <code>
                  &lt;ui:dropdownlist id="[name]" name="[uiname]"
                  <br/>
                  <div style="padding-left: 50px">
                    ui:items="//data/*" ui:field="@index" ui:index="."/&gt;
                  </div>
                </code>
              </td>
            </tr>
            <tr>
              <td >
                ui:dropdownlist
              </td>
              <td>
                <ui:dropdownlist id="dropdown" name="dd5" style="width: 200px;">
                  <option value="ui1">Text UI-1</option>
                  <option value="ui2">Text UI-2</option>
                </ui:dropdownlist>
              </td>
              <td>
                use template defined values for DropDownList
                <code><pre style="margin:0;"><![CDATA[
<ui:dropdownlist id="dropdown" name="dd5" style="width: 200px;">
  <option value="ui1">Text UI-1</option>
  <option value="ui2">Text UI-2</option>
</ui:dropdownlist>]]></pre></code>
              </td>
            </tr>

            <!-- ///////////////////////////////////////////////////////////////////////////////////////// -->
            <tr style="background-color: #90ECEC;">
              <th colspan="3" >using xsl:include, xsl:for-each, JavaScript handling </th>
            </tr>
            
            <tr>
              <td>
                xsl:include
              </td>
              <td>
                <xsl:call-template name="pnlMain1"/><br/>
                <xsl:call-template name="pnlMain2"/>
              </td>
              <td>processing for &lt;xsl:include&gt;<br/>
              <code><pre style="margin:0;">
              <![CDATA[
<xsl:call-template name="pnlMain1"/><br/>
<xsl:call-template name="pnlMain2"/>
                ]]>
              </pre></code>
              
            </td>
            </tr>
            <tr>
              <td>xsl:for-each</td>
              <td>
                <xsl:for-each select="//page/data/*">
                  <xsl:variable name="item" select="current()"/>
                  <ui:radio id="rbRadioButton" value="{$item}"/>
                  <ui:checkbox id="cbCheckBox" ui:index="{@index}"/>
                </xsl:for-each>
              </td>
              <td>
                <code><pre style="margin:0;"><![CDATA[
<xsl:for-each select="//page/data/*">
  <xsl:variable name="item" select="current()"/>
  <ui:radio id="rbRadioButton" value="{$item}"/>
  <ui:checkbox id="cbCheckBox" ui:index="{@index}"/>
</xsl:for-each>
]]></pre></code>
              </td>
            </tr>
            <tr>
              <td>OnSubmit() handing</td>
              <td>
                <input type="button"  value="set handler" onclick="setHandler();" />
                <script>
function setHandler( event )
{
   _temis.onSubmit.addAction( "alert( 'user action' );" );
}
                </script>
             </td>
             <td>
                <code><pre style="margin:0;"><![CDATA[
<script>
<input type="button"  value="set handler" onclick="setHandler();" );" />
function setHandler( event )
{
   _temis.onSubmit.addAction( "alert( 'user action onSubmit()' );" );
}
</script>

]]></pre></code>

             </td>
            </tr>
          </table>

          <p>
            <b>Note:</b>You can override some attributes from XSL template.
          </p>

          XML source: <a href="page.xml">page.xml</a><br/>
          XSL source: <a href="page1.xsl">page1.xsl</a><br/>
          XSL source: <a href="page2.xsl">page2.xsl</a><br/>
          XSL source: <a href="page3.xsl">page3.xsl</a>

        </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
