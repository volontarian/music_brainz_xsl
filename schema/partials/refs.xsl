<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="ref.xsl"/>
  <xsl:template name="refs">
    <xsl:param name="parent"/>
    <refs>
      <xsl:for-each select="./*[name()='ref'] | ./optional/*[name()='ref'] | ./optional/choice/*[name()='ref'] | ./zeroOrMore/*[name()='ref']">
        <xsl:variable name="ref_name" select="./@name"/>
        <xsl:if test="count(/grammar/define[@name=$ref_name]/*[1]/*) > 1 or ./@name = 'def_ipi-list' or ./@name = 'def_iswc-list' or ./@name = 'def_artist-credit' or ./@name = 'def_attribute-list'">
          <xsl:variable name="replaced_ref_name">
            <xsl:choose>
              <xsl:when test="contains(./@name, 'def_') and contains(./@name, '-element')">
                <xsl:value-of select="substring(./@name, 5, string-length(./@name) - 12)"/>
              </xsl:when>
              <xsl:when test="contains(./@name, 'def_')">
                <xsl:value-of select="substring(./@name, 5, string-length(./@name) - 4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="./@name"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="{$replaced_ref_name}">
            <xsl:choose>
              <xsl:when test="./@name = 'def_iswc-list'">
                <resource>
                  <name>iswc</name><type><name>String</name><comment>[A-Z]-[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]</comment></type>
                </resource>
              </xsl:when>
              <xsl:when test="./@name = 'def_attribute-list'">
                <resource>
                  <name>attribute</name><type><name>String</name></type>
                </resource>
              </xsl:when>
              <xsl:when test="./@name = 'def_ipi-list'">
                <resource>
                  <name>ipi</name>
                  <type><name>String</name><comment>[0-9]{11}</comment></type>
                </resource>
              </xsl:when>
              <xsl:when test="./@name = 'def_artist-credit'">
                <resource>
                  <parent>name-credit</parent><parent_attribute>joinphrase</parent_attribute><name>artist</name>
                </resource>
              </xsl:when>
              <xsl:when test="contains(./@name, 'list')">
                <xsl:variable name="next_replaced_ref_name">
                  <xsl:choose>
                    <xsl:when test="contains(/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name, 'def_') and contains(/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name, '-element')">
                      <xsl:value-of select="substring(/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name, 5, string-length(/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name) - 12)"/>
                    </xsl:when>
                    <xsl:when test="contains(./@name, 'def_')">
                      <xsl:value-of select="substring(/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name, 5, string-length(/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name) - 4)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="/grammar/define[@name=$ref_name]/*[1]/zeroOrMore/ref/@name"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <resource>
                  <name><xsl:value-of select="$next_replaced_ref_name"/></name>
                </resource>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$parent != ''"><parent><xsl:value-of select="$parent"/></parent></xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </refs>
  </xsl:template>
</xsl:stylesheet>
  