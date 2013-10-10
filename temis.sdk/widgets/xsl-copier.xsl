<temis:stylesheet
    xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    xmlns:ui="ui.dtd" xmlns:Xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="ui"
    version="1.0">

  <temis:template match="*" mode="temis-copy-attributes">
    <!-- copy attributes  -->
    <temis:for-each select="@*[not(contains(name(),'ui:') or name() = 'id')]">
      <temis:attribute name="{name()}">
        <temis:value-of select="."/>
      </temis:attribute>
    </temis:for-each>

    <temis:apply-templates select="." mode="temis-check-disable"/>
  </temis:template>


  <temis:template match="*" mode="temis-check-disable">

    <temis:choose>
      <temis:when test="@disabled='1' or @disabled='yes' ">
        <!-- nothing todo -->
      </temis:when>
      <temis:when test="$enable-test-disabled='yes'">
          <xsl:if test="{{$temis-object}}/disabled = '1'">
            <xsl:attribute name="disabled">1</xsl:attribute>
          </xsl:if>
      </temis:when>
      <temis:otherwise>
        <!-- nothing todo -->
      </temis:otherwise>
    </temis:choose>
  </temis:template>

  <temis:template match="@ui:tooltip">
    <temis:attribute name="title">
      <temis:apply-templates mode="ui:message" select="."/>
    </temis:attribute>
  </temis:template>


</temis:stylesheet>