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
<!--
     
     File input control 
     ========

     Description:

     File Input 
     
       
     Element name:
       
       ui:file

     Attributes:   

       @id             - object ID
       @value          - value of textbox button, xpath available ({source})
       @onchange       - override standard action on change
       @ui:caption     - file input button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)

     another HTML attrbutes is available
       
     Inner text:
     
       is not used

     -->
<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="ui "
  version="1.0">

  <!-- UI button generator -->
  <temis:template name="ui:file" match="ui:file">

    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>

    <xsl:if test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="file"
             id  ="{{$temis-object/__name}}{$index-id}"
             name="{{$temis-object/__name}}{$index-name}">

        <temis:apply-templates select="." mode="temis-copy-attributes"/>
        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onchange</temis:with-param>
        </temis:apply-templates>

        <!-- insert user code here  -->
        <temis:apply-templates select="*"/>

      </input>
    </xsl:if>


  </temis:template>

</temis:stylesheet>
