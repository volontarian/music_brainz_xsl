<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" cdata-section-elements="headline intro body" />
  <xsl:template match="/">
    <xsl:for-each select="./grammar/define">
      <xsl:choose>
        <xsl:when test="./@name = 'def_metadata-element'"/>
        <!-- TODO: consider attribute target-type @def_relation-list -->
        <xsl:when test="./@name = 'def_medium-list' or ./@name = 'def_relation-list' or ./@name = 'def_attribute-list' or ./@name = 'def_list-attributes' or ./@name = 'def_ipi-list'"/>
        <xsl:when test="contains(./@name, 'list')">
          <xsl:choose>
            <xsl:when test="count(./element) = 1">
              <xsl:choose>
                <xsl:when test="count(./element[1]/*) = 2 and name(./element[1]/*[1]) = 'ref' and name(./element[1]/*[2]) = 'zeroOrMore' and count(./element[1]/*[2]/*) = 1 and name(./element[1]/*[2]/*[1]) = 'ref'"/>
                <xsl:otherwise>
                  <xsl:element name="{./@name}">
                    <xsl:call-template name="error"><xsl:with-param name="message">Not implemented.</xsl:with-param></xsl:call-template>
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="{./@name}">
                <xsl:call-template name="error"><xsl:with-param name="message">Not implemented.</xsl:with-param></xsl:call-template>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>  
        </xsl:when>
        <xsl:when test="count(./element) = 1 and count(./*[1]/*) &gt; 1 and ./element/@name != ''">
          <xsl:for-each select="./element"><xsl:call-template name="element_with_optionals"/></xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="element_with_optionals">
    <xsl:param name="parent"/>
    <xsl:element name="{./@name}">
      <attributes>
        <xsl:for-each select="./optional/*[name()='attribute']">
          <xsl:call-template name="attribute">
            <xsl:with-param name="parent" select="$parent"/>
            <xsl:with-param name="name" select="./@name"/>
          </xsl:call-template>
        </xsl:for-each>
      </attributes>
      <elements>
        <xsl:for-each select="./optional/*[name()='element']">
          <xsl:variable name="element_name" select="./@name"/>
          <xsl:choose>
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
        <xsl:for-each select="./optional/*[name()='ref']">
          <xsl:variable name="ref_name" select="./@name"/>
          <xsl:if test="name(/grammar/define[@name=$ref_name]/*[1]) = 'element' and count(/grammar/define[@name=$ref_name]/*[1]/*) = 1">
            <xsl:choose>
              <xsl:when test="./@name = 'def_ipi-list'"/>
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
      <refs>
        <xsl:for-each select="./optional/*[name()='ref']">
          <xsl:variable name="ref_name" select="./@name"/>
          <xsl:if test="count(/grammar/define[@name=$ref_name]/*[1]/*) > 1 or ./@name = 'def_ipi-list'">
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
                <xsl:when test="./@name = 'def_ipi-list'">
                  <resource>
                    <name>ipi</name>
                    <type><name>String</name><comment>[0-9]{11}</comment></type>
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
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="attribute">
    <xsl:param name="parent"/>
    <xsl:param name="name"/>
    <xsl:element name="{$name}">
      <xsl:if test="$parent != ''"><parent>{$parent}</parent></xsl:if>
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
  
  <xsl:template name="element">
    <xsl:param name="parent"/>
    <xsl:param name="name"/>
    <xsl:element name="{$name}">
      <xsl:if test="$parent != ''"><parent><xsl:value-of select="$parent"/></parent></xsl:if>
      <xsl:for-each select="./*"><xsl:call-template name="value"/></xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="value">
    <xsl:choose>
      <xsl:when test="name(.) = 'text'"><type><name>String</name></type></xsl:when>
      <xsl:when test="name(.) = 'data' or name(.) = 'ref' or name(.) = 'choice'">
        <xsl:apply-templates select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error">
          <xsl:with-param name="message">Not implemented.</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="ref">
    <xsl:variable name="ref_name" select="./@name"/>
    <xsl:choose>
      <xsl:when test="$ref_name = 'def_incomplete-date'">
        <type><name>IncompleteDate</name></type>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="ref_child_tag_name" select="name(/grammar/define[@name=$ref_name][1]/*[1])"/>
        <xsl:if test="$ref_child_tag_name = 'data' or $ref_child_tag_name = 'choice'">
          <xsl:apply-templates select="/grammar/define[@name=$ref_name][1]/*[1]" />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
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
  
  <xsl:template match="data">
    <xsl:choose>
      <xsl:when test="./@type = 'string' or ./@type = 'anyURI'">
        <type>
          <name>String</name>
          <comment><xsl:value-of select="./param[@name='pattern'][1]"/></comment>
        </type>
      </xsl:when>
      <xsl:when test="./@type = 'nonNegativeInteger'"><type><name>Integer</name></type></xsl:when>
      <xsl:when test="./@type = 'float'"><type><name>Float</name></type></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error">
          <xsl:with-param name="message">Not implemented: unknown data type.</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="error">
    <xsl:param name="message"/>
    <xsl:param name="xpath"/>
    <error>
      <message><xsl:value-of select="$message"/></message>
      <xml><xsl:copy-of select="." /></xml>
    </error>
  </xsl:template>
</xsl:stylesheet>