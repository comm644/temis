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
     
     Test Visiblility container
     ===========================

     Description:

     Test visiblity according to specified item
     
       
     Element name:
       
       ui:visible

     Attributes:   

       @id             - object ID
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign

       another HTML attrbutes is available
       
     Inner text:

       user defined tags
       
         />
         
     -->
<temis:stylesheet xmlns:temis="http://www.w3.org/1999/XSL/Transform"
                  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
                version="1.0">


  <temis:template match="ui:visible[@ui:visibility = 'no']"/>

  <temis:template match="ui:visible[@ui:visibility = 'yes']">
    <temis:apply-templates select="*|text()"/>
  </temis:template>

  <temis:template match="ui:visible[@ui:visibility = 'test' or count(@ui:visibility) = 0]">
      <!-- insert user code here  -->
      <temis:apply-templates select="*|text()"/>
  </temis:template>

</temis:stylesheet>
