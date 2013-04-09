<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="choice">
    <type>
      <xsl:choose>
        <xsl:when test="count(./value) = 1 and (./value[1] = 'true' or ./value[1] = 'false')">
          <name>Boolean</name>
        </xsl:when>
        <xsl:when test="count(./value) = 2 and (./value[1] = 'true' or ./value[1] = 'false') and (./value[2] = 'true' or ./value[2] = 'false')">
          <name>Boolean</name>
        </xsl:when>
        <xsl:otherwise>
          <name>String</name>
          <comment>
            <xsl:for-each select="./value">
              <xsl:if test="position() > 1">, </xsl:if> 
              <xsl:value-of select="."/>
            </xsl:for-each>
          </comment>
        </xsl:otherwise>
      </xsl:choose>
    </type>
  </xsl:template>
</xsl:stylesheet>