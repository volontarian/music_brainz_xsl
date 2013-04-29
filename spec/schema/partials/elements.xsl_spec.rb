require 'spec_helper'

describe 'schema/partials/elements.xsl' do
  include_examples 'schema/partials/value.xsl', 'element'
  include_examples 'schema/partials/data.xsl', 'element'
  
  context "./*[name()='element] ./optional/*[name()='element']" do
    context './@name = "target"' do
      it 'returns the element hard coded' do
        transform_grammar(%Q{<define name="def_relation-element">
          <element name="relation">
            <element name="target"><optional><attribute name="id"><data type="anyURI"/></attribute></optional><data type="anyURI"/></element>
            <optional/>
          </element>
        </define>}).should == strip_xml(%Q{<relation>
          <attributes/>
          <elements><target><type><name>String</name></type></target></elements>
          <refs/>
        </relation>})
      end  
    end
    
    describe 'support nested elements' do
      # will only work for 2 levels as described in this example
      context 'nested optional' do
        it 'works' do
          transform_grammar(%Q{<define name="def_artist-element">
            <element name="artist">
              <optional>
                <element name="parent">
                  <optional><element name="name1"><text/></element></optional>
                  <optional><element name="name2"><text/></element></optional>
                </element>
              </optional>
              <optional/>
            </element>
          </define>}).should == strip_xml(%Q{<artist>
            <attributes/>
            <elements>
              <name1><parent>parent</parent><type><name>String</name></type></name1>
              <name2><parent>parent</parent><type><name>String</name></type></name2>
            </elements>
            <refs/>
          </artist>})
        end
      end
      
      context 'nested optional zeroOrMore' do
        it 'works' do
          transform_grammar(%Q{<define name="def_artist-element">
            <element name="artist">
              <optional>
                <element name="parent-list">
                  <optional><zeroOrMore><element name="name"><text/></element></zeroOrMore></optional>
                </element>
              </optional>
              <optional/>
            </element>
          </define>}).should == strip_xml(%Q{<artist>
            <attributes/>
            <elements>
              <name><parent>parent-list</parent><type><name>String</name></type></name>
            </elements>
            <refs/>
          </artist>})
        end
      end
    end
  end
  
  context "./optional/*[name()='ref']" do
    context 'element from ref with 1 element' do
      context 'ref with obligatory or optional element' do
        it 'works' do
          [['', ''], ['<optional>', '</optional>']].each do |tag|
            transform_grammar(%Q{<define name="def_artist-element">
              <element name="artist">
                <optional><ref name="def_example"/></optional>
                <optional/>
              </element>
            </define>
            <define name="def_example">
              <element name="name">#{tag.first}<text/>#{tag.last}</element>
            </define>}).should == strip_xml(%Q{<artist>
              <attributes/>
              <elements>
                <name><type><name>String</name></type></name>
              </elements>
              <refs/>
            </artist>})
          end
        end
      end
    end
  end
  
  context '/*[name()="text"]' do
    it 'returns 1 name element' do
      transform_grammar(%Q{<define name="def_alias">
        <element name="alias"><optional/><text/></element>
      </define>}).should == strip_xml(%Q{<alias>
        <attributes/>
        <elements>
          <name><from>../alias</from><type><name>String</name></type></name>
        </elements>
        <refs/>
      </alias>})
    end
  end
end 