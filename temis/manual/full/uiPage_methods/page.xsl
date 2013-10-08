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

        <h1>Test uiPage methods</h1>

        <h2>Reload current page</h2>

        <p>
          Reload current page
        </p>
        <pre>
<![CDATA[
  PHP:
  
  $this->reload();
]]>     </pre>
        <ui:button id="btnReload" ui:caption="Reload"/>

        <h2>Redirect to other page</h2>

        <p>
        Redirect to other page and destroy content of current page ($self)
        </p>
        
        <pre>
<![CDATA[
  PHP:
  
  $this->redirect('redirect url');
]]>     </pre>
        <ui:button id="btnRedirect" ui:caption="Redirect"/>


        <h2>Close current page</h2>

        <p>
          Destroy content of current page and close pop-up window.
        </p>
        <p>
          Can be used for workign with pop-up windows.
        </p>
        <pre>
<![CDATA[
  PHP:
  
  $this->close();
]]>     </pre>
        <ui:button id="btnClose" ui:caption="Close"/>

        <h2>Return to previous page</h2>

        <p>
          Performs redirect to previous page (parent) with destorying current page content
        </p>
        <pre>
<![CDATA[
  PHP:
  
  $this->back();
]]>     </pre>
  
        <ui:button id="btnBack" ui:caption="Back"/>

        <xsl:call-template name="insert-footer"/>
      </body>
    </html>

  </xsl:template>


</xsl:stylesheet>
