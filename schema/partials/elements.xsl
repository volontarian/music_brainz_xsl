<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="elements">
    <xsl:param name="parent"/>
    <elements>
      <xsl:for-each select="./*[name()='element'] | ./optional/*[name()='element']">
        <xsl:variable name="element_name" select="./@name"/>
        <xsl:choose>
          <xsl:when test="./@name = 'target'">
            <xsl:element name="{./@name}"><type><name>String</name></type></xsl:element>
          </xsl:when>
          <xsl:when test="count(./*) &gt; 1 or name(./optional/*[1]) = 'zeroOrMore'">
            <xsl:for-each select="./optional/zeroOrMore/element | ./optional/element">
              <xsl:call-template name="element">
                <xsl:with-param name="parent" select="$element_name"/>
                <xsl:with-param name="name" select="./@name"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="element">
              <xsl:with-param name="parent" select="$parent"/>
              <xsl:with-param name="name" select="./@name"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="./*[name()='ref'] | ./optional/*[name()='ref']">
        <xsl:variable name="ref_name" select="./@name"/>
        <xsl:if test="name(/grammar/define[@name=$ref_name]/*[1]) = 'element' and count(/grammar/define[@name=$ref_name]/*[1]/*) = 1">
          <xsl:choose>
            <xsl:when test="./@name = 'def_ipi-list' or ./@name = 'def_artist-credit' or ./@name = 'def_attribute-list'"/>
            <xsl:when test="name(/grammar/define[@name=$ref_name]/*[1]/*[1]) = 'optional'">
              <xsl:if test="count(/grammar/define[@name=$ref_name]/*[1]/*[1]/*) = 1">
                <xsl:for-each select="/grammar/define[@name=$ref_name]/*[1]/*[1]">
                  <xsl:call-template name="element">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="name" select="../@name"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="/grammar/define[@name=$ref_name]/*[1]">
                <xsl:call-template name="element">
                  <xsl:with-param name="parent" select="$parent"/>
                  <xsl:with-param name="name" select="./@name"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
      
    </elements>
  </xsl:template>
  
  <xsl:template name="element">
    <xsl:param name="parent"/>
    <xsl:param name="name"/>
    <xsl:element name="{$name}">
      <xsl:if test="$parent != ''"><parent><xsl:value-of select="$parent"/></parent></xsl:if>
      <xsl:for-each select="./*"><xsl:call-template name="value"/></xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
  