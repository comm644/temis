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
    encoding="utf-8"
    />

  <!--
       doctype-public="-//W3C//DTD HTML 4.01//EN"
       doctype-system="http://www.w3.org/TR/1999/REC-html401-19991224/strict.dtd"
       -->
  <xsl:include href="../common.xsl"/>

  <xsl:template match="/">

    <html>
      <xsl:call-template name="insert-head"/>
      <body>
        <xsl:call-template name="insert-header"/>

        <h1>Test ui:insert-panel</h1>


        <h2>Create panel</h2>
        <ol>
          <li>Instead creating xsl:template/xsl:call-template use ui:panel/ui:instert-panel</li>
          <li>Panel should be created under xsl:stylesheet</li>
          <li>Remember: UI control ui:panel will be converted into xsl:template</li>
        </ol>
        <pre><![CDATA[
<ui:panel ]]><span class='red'>id="panelID"</span><![CDATA[>
     <p>some content</p>
</ui:panel>]]></pre>

        <h2>Insert panel, place holder</h2>
        This  tag also Known as "Place holder"
        <div style="width:500pt;" class="attention">
          Note:
          The panel might be included into another panel, but can'not be duplicated,
          because each panel has have ID in global space of page.
        </div>
        <pre><![CDATA[<ui:insert-panel ]]><span class='red'>id="panelID"</span><![CDATA[/>]]></pre>

        <h2>Targeting, how to update panel</h2>
        <ol>
          <li>
             Create some button or another object with auto-postback server handler
          </li>
          <li>
             Set target
          </li>
        </ol>
        <pre><![CDATA[<ui:button id="btnUpdate"
        ui:caption="Update first"
        ]]><span class='red'>ui:target="panelID"</span><![CDATA[/>]]></pre>


        <h2>Duplicating panels and using with for-each</h2>

        You can duplicate panel with some with additinal steps:
        <ol class="wide">
          <li>Write code for duplicating:
          <pre>
            <![CDATA[
 <xsl:for-each select="items/*">

   ]]><span class="bold">insert some button or other control with AJAX target:</span><![CDATA[

   <ui:button id="btnUpdate" ui:caption="Update me"
     ui:target="panelID" ]]><span class="red">ui:target-index="{@index}"</span><![CDATA[/>

   ]]><span class="bold">and insert place holder</span><![CDATA[

   <ui:insert-panel id="panelID" ]]><span class="red">ui:index="{@index}"</span><![CDATA[/>

 </xsl:for-each>]]>
           </pre>
          </li>
          <li>
            Write panel inners for using with indexer
            <pre>
            <![CDATA[
 <ui:panel id="panelID" >
   ]]><span class="bold"><![CDATA[
   You can to use predefined variable:
   $ui-index - current index value, which you transmit in ui:index attribute ]]>
   </span><![CDATA[
   <xsl:variable name="item" select="items/*[@index=]]><span class="red">$ui-index</span><![CDATA[]"/>

   some panel content
   Index: <xsl:value-of select="$ui-index"/>
   Value: <xsl:value-of select="$item/text()"/>
   some page values: <xsl:value-of select="counter"/>

 </ui:panel>]]>
            </pre>
          </li>
        </ol>
        Hints:
        <ol>
          <li>
            You can to use predefined variable $ui-index which you have transmited in ui:index attribute.
          </li>
          <li>Current for-each context will be unaccesbbile via current() because the same panel code
          will called in AJAX request.

          </li>
        </ol>

          <p>
          Demo:
          <xsl:for-each select="items/*">
            <p>
              <ui:button id="btnUpdate" ui:caption="Update me" ui:target="indexed" ui:target-index="{@index}"/>
              <ui:insert-panel id="indexed" ui:index="{@index}"/>
            </p>
          </xsl:for-each>
        </p>

        <h2>User defined place-holder</h2>

        You can to define HTML tag for place holder for getting pretty view.
        <pre><![CDATA[
<ui:panel id="panelID"]]><span class='red'> ui:place-holder="TagName"</span><![CDATA[>
   some content
</ui:panel>]]></pre>




         <p>
           Demo:
           <ui:insert-panel id="userHolder" />
         </p>


        <h2>AJAX driven Demo</h2>
        <div class="border padding2" style="background-color:#D9D9D9;">
          <p>
            Page content
          </p>

          <ui:button id="btnUpdate" ui:caption="Update me"/>
          <ui:button id="btnUpdate" ui:caption="Update first" ui:target="panel1"/>
          <ui:button id="btnUpdate" ui:caption="Update second" ui:target="panel2"/>
          <ui:button id="btnUpdate" ui:caption="Update inner" ui:target="panelInner"/>

          <br/>

          Text updated from server: <xsl:value-of select="text"/>

          <ui:insert-panel id="panel1" />
          <ui:insert-panel id="panel2"/>
        </div>

        <h2>Load Extenal JS</h2>
        <ui:insert-panel id="externalJS"/>

        <h2>Execute Embedded  JS</h2>
        <ui:insert-panel id="embeddedJS"/>

        
        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>

  <ui:panel id="panel1" class="border padding2" style="background-color:#C3C8EE;">
    <p>
      First panel content
    </p>

    <ui:button id="btnUpdate" ui:caption="Update all"/>
    <ui:button id="btnUpdate" ui:caption="Update me" ui:target="panel1"/>
    <ui:button id="btnUpdate" ui:caption="Update second" ui:target="panel2"/>
    <ui:button id="btnUpdate" ui:caption="Update inner" ui:target="panelInner"/>
    <br/>

    Text updated from server: <xsl:value-of select="text"/>

    <ui:insert-panel id="panelInner"/>

  </ui:panel>

  <ui:panel id="panel2" class="border padding2" style="background-color:#D5F8C7;">
    <p>
      Second panel content
    </p>
    <ui:button id="btnUpdate" ui:caption="Update all"/>
    <ui:button id="btnUpdate" ui:caption="Update first" ui:target="panel1"/>
    <ui:button id="btnUpdate" ui:caption="Update me" ui:target="panel2"/>
    <ui:button id="btnUpdate" ui:caption="Update inner" ui:target="panelInner"/>
    <br/>

    Text updated from server: <xsl:value-of select="text"/>

  </ui:panel>

  <ui:panel id="panelInner" class="border padding2" style="background-color:#F3E6A7">
    <p>
      Inner panel content
    </p>
    <ui:button id="btnUpdate" ui:caption="Update all"/>
    <ui:button id="btnUpdate" ui:caption="Update first" ui:target="panel1"/>
    <ui:button id="btnUpdate" ui:caption="Update second" ui:target="panel2"/>
    <ui:button id="btnUpdate" ui:caption="Update me" ui:target="panelInner"/>
    <br/>

    Text updated from server: <xsl:value-of select="text"/>

  </ui:panel>


  <ui:panel id="userHolder" ui:place-holder="span" class="border">
    This panel uses user defined place-holder tag. In this sample: SPAN
  </ui:panel>

  <ui:panel id="indexed" ui:place-holder="span" >
    <!-- predefined variables:

         $ui-index - current index value
         -->
    <xsl:variable name="item" select="items/*[@index=$ui-index]"/>

    (The panel  index=
      <xsl:value-of select="$ui-index"/>
      &nbsp;Name:
      <xsl:value-of select="$item/text()"/>)
      counter= <xsl:value-of select="counter"/>

  </ui:panel>

  <ui:panel id="externalJS">
    <ui:button id="btnUpdate" ui:caption="Update me" ui:target="externalJS"/>
    
    <div id="externalJS$holder">
      FAILED: external script does not loaded
    </div>
    <xsl:value-of select="text"/>

    <script language="javascript" src="some.js"></script>
    
  </ui:panel>

  <ui:panel id="embeddedJS">
    <ui:button id="btnUpdate" ui:caption="Update me" ui:target="embeddedJS"/>

    <div id="embeddedJS$holder">
      FAILED: embedded script does not loaded
    </div>
    <xsl:value-of select="text"/>
    
    <script>
      
var e = document.getElementById( 'embeddedJS$holder' );
e.innerHTML = "SUCCESS: embedded JavaScript loaded";

    </script>

  </ui:panel>
</xsl:stylesheet>
