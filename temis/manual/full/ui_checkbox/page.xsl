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

     This is test page for testing Ui:checkbox properties

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
        <h1>Test ui:checkbox</h1>

        <h2>User Attributes</h2>
        
        <p>
          <pre><![CDATA[<ui:checkboxid="checkbox1" value="r1" class='red'/>]]></pre>
          <ui:checkbox id="checkbox1" value="r1" class="sample" style='width:20px;height:20px;'/>
        </p>

        <h2>Set value</h2>
        <h3>Simple checkbox button: </h3>
        <p>
          <pre><![CDATA[<ui:checkbox ]]><span class="red">id="checkbox1"</span><![CDATA[ value="r1"/>]]></pre>
          <ui:checkbox id="checkbox1" value="r1"/>
        </p>

        <h3>xpath value:</h3>
        <p>
          <xsl:variable name="var">r3</xsl:variable>
          <pre><![CDATA[
<xsl:variable name="var">r3</xsl:variable>
<ui:checkbox id="checkbox1" ]]><span class="red">value="{$var}</span><![CDATA["/>]]></pre>
          <ui:checkbox id="checkbox1" value="{$var}"/>
        </p>

        <h2>Set caption</h2>
        <h3>with caption</h3>
        <p>

          <pre><![CDATA[<ui:checkbox id="checkbox1" value="r2" ]]><span class="red">ui:caption="caption"</span><![CDATA[/>]]></pre>
          <ui:checkbox id="checkbox1" value="r2" ui:caption="caption"/>
        </p>

        <h3>xpath caption</h3>
        <p>
          <xsl:variable name="caption">xpath caption</xsl:variable>
          <pre><![CDATA[
<xsl:variable name="caption">xpath caption</xsl:variable>
<ui:checkbox id="checkbox1" value="r4" ]]><span class="red">ui:caption="{$caption}</span><![CDATA["/>]]></pre>
          <ui:checkbox id="checkbox1" value="r4" ui:caption="{$caption}"/>
        </p>

        <h2>Actions</h2>

        <h3>On click - default </h3>
        <p>
          default action on click performs without auto post back.
          <pre>
<![CDATA[
  PHP:

  $this->checkboxClick = new uiCheckbox();
  $this->checkboxClick->]]><span class="red">onclick</span><![CDATA[->]]><span class="red">addHandler</span><![CDATA[( 'onclick' );
]]>
          </pre>
          <ui:checkbox id="checkboxClick" ui:caption="caption"/>
        </p>

        <h3>On click - with auto postback </h3>
        <p>

          Performs auto postback on click
          <pre>
<![CDATA[
  PHP:

  $this->checkboxClickAuto = new uiCheckbox();
  $this->checkboxClickAuto->]]><span class="red">onclick</span><![CDATA[->addHandler( 'onclick' );
  $this->checkboxClickAuto->]]><span class="red">autoPostBack</span><![CDATA[ = ]]><span class="red">true</span><![CDATA[;
]]>
          </pre>
          <ui:checkbox id="checkboxClickAuto" ui:caption="caption"/>

        </p>

        <h3>On change - default action</h3>
        <p>
          TEMIS provide delayed event delivery when will be executed any post back
          <pre>
<![CDATA[
  PHP:

  $this->checkboxChange = new uiCheckbox();
  $this->checkboxChange->]]><span class="red">onchange</span><![CDATA[->]]><span class="red">addHandler</span><![CDATA[( 'onchange' );
]]>
          </pre>
          <ui:checkbox id="checkboxChange" ui:caption="caption"/>
        </p>

        <h3>On change - with auto postback</h3>
        <p>
        <pre>
<![CDATA[
  PHP:

  $this->checkboxChangeAuto = new uiCheckbox();
  $this->checkboxChangeAuto->onchange->]]><span class="red">addHandler</span><![CDATA[( 'onchange' );
  $this->checkboxChangeAuto->]]><span class="red">autoPostBack</span><![CDATA[ = ]]><span class="red">true</span><![CDATA[;
]]>
        </pre>
        <ui:checkbox id="checkboxChangeAuto" ui:caption="caption"/>
      </p>

        <h2>Indexer</h2>
        <h3>External predefined items</h3>
        <p>
          create checkbox button for each item
          <pre><![CDATA[
<xsl:for-each select="//items/*">
  <ui:checkbox id="checkbox1" ui:caption="{text()}" ]]><span class="red">ui:index="item{@index}"</span><![CDATA[/>
</xsl:for-each>]]></pre>

          <xsl:for-each select="items/*">
            <ui:checkbox id="checkbox1" ui:caption="{text()}" ui:index="item{@index}"/>
          </xsl:for-each>

        </p>

        <h3>Template defined items</h3>
          <pre><![CDATA[
<ui:checkbox id="checkboxIndexer" ui:caption="item1" ]]><span class="red">ui:index="0"</span><![CDATA[/>
<ui:checkbox id="checkboxIndexer" ui:caption="item2" ]]><span class="red">ui:index="1"</span><![CDATA[/>
<ui:checkbox id="checkboxIndexer" ui:caption="item3" ]]><span class="red">ui:index="2"</span><![CDATA[/>]]></pre>
        <ui:checkbox id="checkboxIndexer" ui:caption="item1" ui:index="0"/>
        <ui:checkbox id="checkboxIndexer" ui:caption="item2" ui:index="1"/>
        <ui:checkbox id="checkboxIndexer" ui:caption="item3" ui:index="2"/>



        <h3>Always checked item by template (strobing actions)</h3>
        <pre>
          <![CDATA[
<ui:checkbox id="checkboxIndexer" ui:caption="item4"  ui:index="3" ]]><span class="red">value="1"</span><![CDATA[/>
        ]]></pre>
        <ui:checkbox id="checkboxIndexer" ui:caption="item4" ui:index="3" value="1"/>

        <h3>Always checked/unchecked item by xpath (strobing actions)</h3>
        <p>
        <pre><![CDATA[
<xsl:variable name="var0" select="'0'"/>
<xsl:variable name="var1" select="'1'"/>
<ui:checkbox id="checkboxIndexer" ui:caption="unchecked by xpath"
  ui:index="4" ]]><span class="red">value="{$var0}</span><![CDATA["/>
<ui:checkbox id="checkboxIndexer" ui:caption="checked by xpath"
  ui:index="5" ]]><span class="red">value="{$var1}</span><![CDATA["/>
          ]]></pre>
          <xsl:variable name="var0" select="'0'"/>
          <xsl:variable name="var1" select="'1'"/>
          <ui:checkbox id="checkboxIndexer" ui:caption="unchecked by xpath" ui:index="4" value="{$var0}"/>
          <ui:checkbox id="checkboxIndexer" ui:caption="checked by xpath" ui:index="5" value="{$var1}"/>
        </p>


        <h2>Grouping, select all</h2>

        "Groups" is independed from objects and indexesm becaouse you can organize groups on items space.
        "Groups" it's only UI modifier for checkboxes organization.


        <h3>Static groups</h3>

        <PRE>
          <![CDATA[
NOTE: @ui:index anf HTML tags skipped as non-important, see source for details
            
 <ui:checkbox id="checkboxGroups" ui:caption="Root Group" ]]><span class="red">ui:group-handler="root"</span><![CDATA[/>
    <ui:checkbox id="checkboxGroups" ui:caption="Group1" ]]><span class="red">ui:group="root" </span><span class="blue">ui:group-handler="group1"</span><![CDATA[/>
       <ui:checkbox id="checkboxItems" ui:caption="Item 1" ]]><span class="blue">ui:group="group1"</span><![CDATA[/>
       <ui:checkbox id="checkboxItems" ui:caption="Item 2" ]]><span class="blue">ui:group="group1"</span><![CDATA[/>
    <ui:checkbox id="checkboxGroups" ui:caption="Group1" ]]><span class="red">ui:group="root" </span><span class="green">ui:group-handler="group2"</span><![CDATA[/>
       <ui:checkbox id="checkboxItems" ui:caption="Item 3" ]]><span class="green">ui:group="group2"</span><![CDATA[/>
       <ui:checkbox id="checkboxItems" ui:caption="Item 4" ]]><span class="green">ui:group="group2"</span><![CDATA[/>
]]>
        </PRE>
        <ul>
          <li>
            <ui:checkbox id="checkboxGroups" ui:caption="Root Group" ui:index="root" ui:group-handler="root"/>
            <ul>
              <li>
                <ui:checkbox id="checkboxGroups" ui:caption="Group1" ui:index="0" ui:group="root"  ui:group-handler="group1"/>
                <ul>
                  <li><ui:checkbox id="checkboxItems" ui:caption="Item 1" ui:index="0" ui:group="group1"/></li>
                  <li><ui:checkbox id="checkboxItems" ui:caption="Item 2" ui:index="1" ui:group="group1"/></li>
                </ul>
              </li>
              <li>
                <ui:checkbox id="checkboxGroups" ui:caption="Group1" ui:index="1" ui:group="root" ui:group-handler="group2"/>
                <ul>
                  <li><ui:checkbox id="checkboxItems" ui:caption="Item 3" ui:index="2" ui:group="group2"/></li>
                  <li><ui:checkbox id="checkboxItems" ui:caption="Item 4" ui:index="3" ui:group="group2"/></li>
                </ul>
              </li>
            </ul>
          </li>
        </ul>

        <h3>Dynamic groups</h3>

        <p>
          Usually ror creating checkbox hierarchy need to use xsl:for-each and set @ui:index. (marked as blue)
        </p>
        <p>
          For adding groupping have need to add second indexer for groups and
          set @ui:group-handler and @ui:group attributes. (marked as red)
        </p>
        
        <pre>
<![CDATA[
  <xsl:variable name="group0" select="'0'"/>
  <ui:checkbox id="checkboxItems" ui:caption="{group/title}"
    ui:index="group0{$group0}" ui:group-handler="dyngroup"/>

  <]]><span class="blue">xsl:for-each</span><![CDATA[ select="group/items/*">
    <xsl:variable name="group1" select="position()"/>
    <]]><span class="red">xsl:variable</span><![CDATA[ name="index" select="concat('dyngroup',$group0,position())"/>

    <ui:checkbox id="checkboxItems" ui:caption="{title}"
      ]]><span class="blue">ui:index="{$index}"</span><![CDATA[ ui:group="dyngroup"  ]]><span class="red">ui:group-handler="{$index}"</span><![CDATA[/>
    
    <]]><span class="blue">xsl:for-each</span><![CDATA[ select="items/*">
      <xsl:variable name="group2" select="position()"/>
      <]]><span class="blue">xsl:variable</span><![CDATA[ name="index2" select="concat($index,position())"/>
      <ui:checkbox id="checkboxItems" ui:caption="{text()}"
        ]]><span class="blue">ui:index="{$index2}"</span><span class="red"> ui:group="{$index}"</span><![CDATA[/>
    </xsl:for-each>
    
  </xsl:for-each>
]]>              
        </pre>

        <ul>
          <li>
            <xsl:variable name="group0" select="'0'"/>
            <ui:checkbox id="checkboxItems" ui:caption="{group/title}" ui:index="group0{$group0}" ui:group-handler="dyngroup"/>
            <xsl:for-each select="group/items/*">
              <ul>
              <xsl:variable name="group1" select="position()"/>
              <xsl:variable name="index" select="concat('dyngroup',$group0,position())"/>
              <li>
                <ui:checkbox id="checkboxItems" ui:caption="{title}" ui:index="{$index}" ui:group="dyngroup" ui:group-handler="{$index}"/>
                <ul>
                  <xsl:for-each select="items/*">
                    <xsl:variable name="group2" select="position()"/>
                    <xsl:variable name="index2" select="concat($index,position())"/>
                    <li>
                      <ui:checkbox id="checkboxItems" ui:caption="{text()}" ui:index="{$index2}" ui:group="{$index}"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </li>
            </ul>
            </xsl:for-each>
          </li>
        </ul>
        
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
              <pre><![CDATA[
<ui:checkbox id="checkbox1" 
  ui:visibility=]]><span class="red">"yes"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="checkbox1" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:checkbox id="checkbox1" 
  ui:visibility=]]><span class="red">"no"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="checkbox1" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <th>defined</th>
            <th>by server</th>
            <td>
              <pre><![CDATA[
<ui:checkbox id="checkboxVisible" 
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="checkboxVisible" ui:visibility="test"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:checkbox id="checkboxInvisible" 
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="checkboxInvisible" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <th>defined</th>
            <th>default</th>
            <td>
              <pre><![CDATA[ <ui:checkbox id="checkboxVisible" />]]></pre>
              <ui:checkbox id="checkboxVisible" />
            </td>
            <td>
              <pre><![CDATA[ <ui:checkbox id="checkboxInvisible" />]]></pre>
              <ui:checkbox id="checkboxInvisible" />
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>always</th>
            <td>
              <pre><![CDATA[
<ui:checkbox id="UndefinedCheckbox" 
  ui:visibility=]]><span class="red">"yes"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="UndefinedCheckbox" ui:visibility="yes"/>
            </td>
            <td>
              <pre><![CDATA[
<ui:checkbox id="UndefinedCheckbox" 
  ui:visibility=]]><span class="red">"no"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="UndefinedCheckbox" ui:visibility="no"/>
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>by server</th>
            <td>
              <pre><![CDATA[
<ui:checkbox id="checkboxUndefined" 
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="checkboxUndefined"  ui:visibility="test"/>

            </td>
            <td>
              <pre><![CDATA[
<ui:checkbox id="checkboxUndefined" 
  ui:visibility=]]><span class="red">"test"</span><![CDATA[/>]]></pre>
              <ui:checkbox id="checkboxUndefined" ui:visibility="test"/>
            </td>
          </tr>
          <tr>
            <th>undefined</th>
            <th>default</th>
            <td>
              <pre><![CDATA[<ui:checkbox id="checkboxUndefined"  />]]></pre>
              <ui:checkbox id="checkboxUndefined" />
            </td>
            <td>
              <pre><![CDATA[ <ui:checkbox id="checkboxUndefined" />]]></pre>
              <ui:checkbox id="checkboxUndefined" />
            </td>
          </tr>
        </table>

        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
