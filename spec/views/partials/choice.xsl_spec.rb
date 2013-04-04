require 'spec_helper'

describe 'views/schema.xsl/choice' do
  context 'boolean' do
    it 'works' do
      [
        '<value>true</value><value>false</value>',
        '<value>true</value>', '<value>false</value>'
      ].each do |values|
        transform_grammar(%Q{<define name="def_artist-element">
          <element name="artist">
            <optional>
              <element name="boolean">
                <choice>#{values}</choice>
              </element>
            </optional>
            <optional/>
          </element>
        </define>}).should == strip_xml(%Q{<artist>
          <attributes/>
          <elements>
            <boolean><type><name>Boolean</name></type></boolean>
          </elements>
          <refs/>
        </artist>})
      end
    end
  end
  
  context 'string' do
    it 'works' do
      transform_grammar(%Q{<define name="def_artist-element">
        <element name="artist">
          <optional>
            <element name="selection">
              <choice>
                <value>1</value><value>2</value>
              </choice>
            </element>
          </optional>
          <optional/>
        </element>
      </define>}).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements>
          <selection><type><name>String</name><comment>1, 2</comment></type></selection>
        </elements>
        <refs/>
      </artist>})
    end
  end
end