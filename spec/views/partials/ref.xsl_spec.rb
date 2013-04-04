require 'spec_helper'

describe 'views/schema.xsl/ref' do
  context 'attribute-list' do
    it 'works' do
      transform_grammar(%Q{<define name="def_relation-element">
        <element name="relation">
          <optional><ref name="def_attribute-list"/></optional>
          <optional/>
        </element>
      </define>
      <define name="def_attribute-list">
        <element name="attribute-list"><oneOrMore><element name="attribute"><text/></element></oneOrMore></element>
      </define>}).should == strip_xml(%Q{<relation>
        <attributes/><elements/>
        <refs>
          <attribute-list>
            <resource><name>attribute</name><type><name>String</name></type></resource>
          </attribute-list>
        </refs>
      </relation>})
    end  
  end
  
  context 'def_ipi-list' do
    it 'works' do
      transform_grammar(%Q{
        <define name="def_artist-element"><element name="artist"><optional><ref name="def_ipi-list"/></optional><optional/></element></define>
        <define name="def_ipi-list"><element name="ipi-list"><zeroOrMore><element name="ipi"><ref name="def_ipi"/></element></zeroOrMore></element></define>
        <define name="def_ipi"><data type="string"><param name="pattern">[0-9]{11}</param></data></define>
      }).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements/>
        <refs>
          <ipi-list>
            <resource><name>ipi</name><type><name>String</name><comment>[0-9]{11}</comment></type></resource>
          </ipi-list>
        </refs>
      </artist>})
    end
  end
  
  context 'def_artist-credit' do
    it 'works' do
      transform_grammar(%Q{
        <define name="def_release-element">
          <element name="release">
            <optional><ref name="def_artist-credit"/></optional><optional/>
          </element>
        </define>
        <define name="def_artist-credit"><element name="artist-credit"><oneOrMore><element name="name-credit"><optional><attribute name="joinphrase"><text/></attribute></optional><optional><element name="name"><text/></element></optional><ref name="def_artist-element"/></element></oneOrMore></element></define>
      }).should == strip_xml(%Q{<release>
        <attributes/><elements/>
        <refs>
          <artist-credit>
            <resource>
              <parent>name-credit</parent><parent_attribute>joinphrase</parent_attribute>
              <name>artist</name>
            </resource>
          </artist-credit>
        </refs>
      </release>
      <name-credit>
        <parent>artist</parent>
        <attributes><joinphrase><type><name>String</name></type></joinphrase></attributes>
      </name-credit>})
    end
  end
  
  context 'def_incomplete-date' do
    it 'works' do
      transform_grammar(%Q{
        <define name="def_artist-element">
          <element name="artist">
            <optional><element name="name"><ref name="def_incomplete-date"/></element></optional>
            <optional/>
          </element>
        </define>
        <define name="def_incomplete-date"/>
      }).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements><name><type><name>IncompleteDate</name></type></name></elements>
        <refs/>
      </artist>})
    end
  end
  
  context 'primitive' do
    it 'works' do
      # e.g. data tag
      transform_grammar(%Q{
        <define name="def_artist-element">
          <element name="artist">
            <optional><element name="country"><ref name="def_iso-3166"/></element></optional>
            <optional/>
          </element>
        </define>
        <define name="def_iso-3166">
          <data type="string"><param name="pattern">[A-Z]{2}</param></data>
        </define>
      }).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements><country><type><name>String</name><comment>[A-Z]{2}</comment></type></country></elements>
        <refs/>
      </artist>})
    end
  end
end