<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="attributes">
    <xsl:param name="parent"/>
    <attributes>
      <xsl:for-each select="./*[name()='attribute'] | ./optional/*[name()='attribute']">
        <xsl:call-template name="attribute"><xsl:with-param name="name" select="./@name"/></xsl:call-template>
      </xsl:for-each>
    </attributes>
  </xsl:template>
  
  <xsl:template name="attribute">
    <xsl:param name="name"/>
    <xsl:element name="{$name}">
      <xsl:choose>
        <xsl:when test="count(./*) &gt; 1">
          <xsl:call-template name="error">
            <xsl:with-param name="message">Not implemented: more than 1 ./*.</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="./*"><xsl:call-template name="value"/></xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
