<temis:stylesheet
    xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    xmlns:ui="ui.dtd" xmlns:Xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="ui"
    version="1.0">


  <temis:template match="text()|@*|*" mode="insert-event-param">
    <temis:param name="name"/>
    <xsl:with-param name="{$name}"><temis:apply-templates mode="gen-index-valueof" select="."/></xsl:with-param>
  </temis:template>

  <temis:template match="*" mode="temis-add-handler">
    <temis:param name="event"/>

    <temis:text>
    </temis:text>

    <temis:if test="count( @*[ name() = $event ] ) = 0">
      <xsl:apply-templates select="$temis-object/{$event}" mode="temis-add-handler">
        <temis:apply-templates mode="insert-event-param" select="@ui:index"><temis:with-param name="name" select="'index'"/></temis:apply-templates>
        <temis:apply-templates mode="insert-event-param" select="@ui:target"><temis:with-param name="name" select="'target'"/></temis:apply-templates>
        <temis:apply-templates mode="insert-event-param" select="@ui:target-index"><temis:with-param name="name" select="'target-index'"/></temis:apply-templates>
        <temis:apply-templates mode="insert-event-param" select="@ui:target-window"><temis:with-param name="name" select="'target-window'"/></temis:apply-templates>
      </xsl:apply-templates>
    </temis:if>
  </temis:template>

</temis:stylesheet>