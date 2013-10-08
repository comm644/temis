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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gen="gen.dtd"
  version="1.0"
  >

  <xsl:output method="html"/>

  <xsl:include href="gen-strip-braces.xsl"/>
  
  <xsl:template match="/">
    text
    <xsl:call-template name="gen:replace-braces">
      <xsl:with-param name="text" select="'text'" />
    </xsl:call-template>
    

    {value}text
    <xsl:call-template name="gen:replace-braces">
      <xsl:with-param name="text" select="'{value}text'"/>
    </xsl:call-template>

    {value}text{value}
    <xsl:call-template name="gen:replace-braces">
      <xsl:with-param name="text"  select="'{value}text{value}'" />
    </xsl:call-template>
    
    before{value}text{value}
    <xsl:call-template name="gen:replace-braces">
      <xsl:with-param name="text"  select="'before{value}text{value}'"  />
    </xsl:call-template>

    before{value}text{value}after
    <xsl:call-template name="gen:replace-braces">
      <xsl:with-param name="text"  select="'before{value}text{value}after'"  />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
