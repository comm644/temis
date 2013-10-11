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

  <!--
       <xsl:output method="html"
    standalone="no"
    encoding="utf-8"
    />
       doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
       doctype-public="-//W3C//DTD XHTML 1.1//EN"
       doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
       -->

  <xsl:include href="../common.xsl"/>
  <xsl:template match="/">
    <html>
      <head>
        <style>
          select { width: 10em;}
        </style>
      </head>
      <xsl:call-template name="insert-head"/>
      <body bgcolor="#FFFFFF">
        <xsl:call-template name="insert-header"/>

        <h1>Drop Down list</h1>

        <h2>Simple</h2>
        <pre><![CDATA[<ui:dropdownlist id="dropdown1"/>]]></pre>
        <ui:dropdownlist id="dropdown1"/>

        <h2>With server items</h2>
        
        <h3>With server items and not selected</h3>
        <pre><![CDATA[<ui:dropdownlist id="dropdownItems"/>]]></pre>
        <ui:dropdownlist id="dropdownItems"/>
        
        <h3>Full server controlled widget ( items and current selection)</h3>
        <pre><![CDATA[<ui:dropdownlist id="dropdownSelected"/>]]></pre>
        <ui:dropdownlist id="dropdownSelected"/>

        <h3>With server items and selecting via template</h3>
          <ul>
            <li>Items have loaded from server</li>
            <li>Selected item have setted directly from template, if need always to show one selected value</li>
          </ul>
        <pre>
          <![CDATA[
<ui:dropdownlist id="dropdownItems" ]]><span class="red">value="1"</span><![CDATA[/>
            ]]></pre>
         <p>
           Demo:
           <ui:dropdownlist id="dropdownItems" value="1"/>
         </p>

        <h3>With server items and selecting via xpath</h3>
        <p>
          <ul>
            <li>Items have loaded from server</li>
            <li>Selected item have setted from template via variable or xpath</li>
          </ul>
          <pre>
          <![CDATA[
<xsl:variable name="var" select="'1'"/>
<ui:dropdownlist id="dropdownItems" ]]><span class="red">value="{$var}</span><![CDATA["/>
           ]]></pre>
          <xsl:variable name="var" select="'1'"/>
          <p>
            Demo:
            <ui:dropdownlist id="dropdownItems" value="{$var}"/>
          </p>
        </p>
        
        <h2>With predefined  items</h2>
        
        <h3>With predefiend items + non-selected</h3>
        <pre><![CDATA[
        <ui:dropdownlist id="dropdownTempl">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>]]></pre>
        
        <ui:dropdownlist id="dropdownTempl">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>

        <h3>With predefined items + predefined selected</h3>
        <pre><![CDATA[
        <ui:dropdownlist id="dropdownTempl" value="1">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>]]></pre>
        
        <ui:dropdownlist id="dropdownTempl" value="1">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>

        <h3>With predefined items + predefined selected (xpath)</h3>
        <p>
        <pre><![CDATA[
          <xsl:variable name="var" select="'1'"/>
          <ui:dropdownlist id="dropdownTempl" value="{$var}">
            <option value="0">item1</option>
            <option value="1">item2</option>
            <option value="2">item3</option>
          </ui:dropdownlist>]]></pre>

          <xsl:variable name="var" select="'1'"/>
          <ui:dropdownlist id="dropdownTempl" value="{$var}">
            <option value="0">item1</option>
            <option value="1">item2</option>
            <option value="2">item3</option>
          </ui:dropdownlist>
        </p>

        <h3>With predefiend localized items</h3>
        <pre><![CDATA[
        <ui:dropdownlist id="dropdownTempl">
          <option value="0"><ui:msg id="item1"/></option>
          <option value="1"><ui:msg id="item2"/></option>
          <option value="2"><ui:msg id="item3"/></option>
        </ui:dropdownlist>]]></pre>
        
        <ui:dropdownlist id="dropdownTempl">
          <option value="0"><ui:msg id="item1"/></option>
          <option value="1"><ui:msg id="item2"/></option>
          <option value="2"><ui:msg id="item3"/></option>
        </ui:dropdownlist>
        <h2>With external items (alien)</h2>
        
        <h3>With extern items not selected</h3>
        <pre><![CDATA[
        <ui:dropdownlist id="dropdownTempl"
          ui:items="{//page/items/*}"
          ui:item-index="{@index}"
          ui:item-value="{text()}"
          value="k2"
          />]]></pre>
        <ui:dropdownlist id="dropdownTempl"
          ui:items="{//page/items/*}"
          ui:item-index="{@index}"
          ui:item-value="{text()}"
          value="k2"
          />


        <h3>User generated items</h3>
        <pre><![CDATA[
        <ui:dropdownlist id="dropdownTempl">
          <xsl:for-each select="//page/items/*">
            <option id="@index"><xsl:value-of select="text()"/></option>
          </xsl:for-each>
        </ui:dropdownlist>
        ]]></pre>
        <ui:dropdownlist id="dropdownTempl">
          <xsl:for-each select="//page/items/*">
            <option id="@index"><xsl:value-of select="text()"/></option>
          </xsl:for-each>
        </ui:dropdownlist>

        <h2>Incompletely defined items</h2>
        <p>
          @ui:items defined but @ui:item-index and @ui:item-value not defined
        </p>
        <ui:dropdownlist id="dropdownTempl"
          ui:items="{//page/items/*}"
          value="2"
          />

        <p>
          @ui:items defined but @ui:item-value not defined
        </p>
        <ui:dropdownlist id="dropdownTempl"
          ui:items="{//page/items/*}"
          ui:item-index="{@index}"
          value="2"
          />

        <p>
          @ui:items defined but @ui:item-index not defined
        </p>
        <ui:dropdownlist id="dropdownTempl"
          ui:items="{//page/items/*}"
          ui:item-value="{text()}"
          value="2"
          />
        
        
        <h2>Indexed Items</h2>

        <h3>With server items + server selected</h3>
        <pre><![CDATA[
        <ui:dropdownlist id="dropdownIndexed" ui:index="0"/>
        <ui:dropdownlist id="dropdownIndexed" ui:index="1"/>
        <ui:dropdownlist id="dropdownIndexed" ui:index="2"/>]]></pre>
        
        <ui:dropdownlist id="dropdownIndexed" ui:index="0"/>
        <ui:dropdownlist id="dropdownIndexed" ui:index="1"/>
        <ui:dropdownlist id="dropdownIndexed" ui:index="2"/>

        <h3>Generated with extern items + server selected </h3>
        <pre><![CDATA[
        <xsl:for-each select="/root/page/items/*">
          <ui:dropdownlist
            id="dropdownIndexedAuto"
            ui:index="{@index}"
            ui:items="{/root/page/items/*}"
            ui:item-index="{@index}"
            ui:item-value="{text()}"
            />
        </xsl:for-each>]]></pre>
        <xsl:for-each select="/root/page/items/*">
          <ui:dropdownlist
            id="dropdownIndexedAuto"
            ui:index="{@index}"
            ui:items="{/root/page/items/*}"
            ui:item-index="{@index}"
            ui:item-value="{text()}"
            />
        </xsl:for-each>


        <h2>Actions</h2>

        <h3>On change - server defined action</h3>
        <ui:dropdownlist id="dropdownServerAction">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>
        <ui:button id="btnSubmit" ui:caption="Post values"/>
        Server value: <xsl:value-of select="changeclick"/>
        
        <h3>On change - server defiend + auto postback</h3>
        <ui:dropdownlist id="dropdownAuto">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>
        Server value: <xsl:value-of select="changeclick"/>
        
        <h3>On change - user defined action</h3>
        <ui:dropdownlist id="dropdownUserAction" onchange="alert('some user action');">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>

        <h2>User defined attributes</h2>
        <ui:dropdownlist id="dropdownUserAction" style="width:200px;background-color:yellow;">
          <option value="0">item1</option>
          <option value="1">item2</option>
          <option value="2">item3</option>
        </ui:dropdownlist>
        
        
        <xsl:call-template name="insert-footer"/>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
