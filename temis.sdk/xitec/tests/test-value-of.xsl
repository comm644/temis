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
  xmlns:xitec="xitec.dtd"
                version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="/">

    <xitec:print-mode/>

    doc 
    
    1 will be copied
    <xsl:value-of select="node"/>
    
    2 will be generated with path
    <xsl:value-of select="/object/node"/>

    3 will be generated clean
    <xsl:value-of select="/object/$node"/>

    4 will be copied clean
    <xsl:value-of select="/widget/node"/>
    <xsl:value-of select="/widget/$node"/>

    <xitec:switch-mode mode="widget">
      5 will be copied
      <xsl:value-of select="node"/>
      
      6 will be generated with path
      <xsl:value-of select="/object/node"/>

      7 will be generated clean
      <xsl:value-of select="/object/$node"/>

      8 will be copied clean
      <xsl:value-of select="/widget/node"/>
      <xsl:value-of select="/widget/$node"/>
    </xitec:switch-mode>

    <xitec:switch-mode mode="object">
      9 will be generated
      <xsl:value-of select="node"/>
      
      10 will be generated with path
      <xsl:value-of select="/object/node"/>

      11 will be generated clean
      <xsl:value-of select="/object/$node"/>

      12 will be copied clean
      <xsl:value-of select="/widget/node"/>
      <xsl:value-of select="/widget/$node"/>
    </xitec:switch-mode>
    
  </xsl:template>
</xsl:stylesheet>
