require 'spec_helper'

describe 'views/schema.xsl/resource' do
  context 'def_nonmb-track' do
    it 'resource tag name set to nonmb-track' do
      transform_grammar(%Q{<define name="def_nonmb-track">
        <element name="track">
          <optional><element name="name"><text/></element></optional>
          <optional/>
        </element>
      </define>}).should == strip_xml(%Q{<nonmb-track>
        <attributes/>
        <elements><name><type><name>String</name></type></name></elements>
        <refs/>
      </nonmb-track>})
    end
  end
  
  it 'transforms optional and obligatory items' do
    input = %Q{<define name="def_resource"><element name="resource">}
    expected = %Q{<resource>}
    
    ['attribute', 'element', 'ref'].each do |item_type|
      name_prefix = item_type == 'ref' ? 'def_' : ''
      value = item_type == 'ref' ? '' : '<text/>'
      input += %Q{
        <#{item_type} name="#{name_prefix}obligatory-#{item_type}">#{value}</#{item_type}>
        <optional>
          <#{item_type} name="#{name_prefix}optional-#{item_type}">#{value}</#{item_type}>
        </optional>
      }
      
      expected += %Q{<#{item_type}s>}
      
      if item_type == 'ref'
        expected += %Q{<obligatory-#{item_type}/><optional-#{item_type}/>}
      else
        expected += %Q{
          <obligatory-#{item_type}><type><name>String</name></type></obligatory-#{item_type}>
          <optional-#{item_type}><type><name>String</name></type></optional-#{item_type}>
        }
      end
        
      expected += %Q{</#{item_type}s>}
    end
    
    expected += %Q{
      </resource>
      <obligatory-ref>
        <attributes/><elements><name><type><name>String</name></type></name></elements><refs/>
      </obligatory-ref>
      <optional-ref>
        <attributes/><elements><name><type><name>String</name></type></name></elements><refs/>
      </optional-ref>
    }
    input += %Q{
       </element>
      </define>
      <define name="def_obligatory-ref"><element name="obligatory-ref"><element name="name"><text/></element><optional/></element></define>
      <define name="def_optional-ref"><element name="optional-ref"><element name="name"><text/></element><optional/></element></define>
    }
    
    transform_grammar(input).should == strip_xml(expected)
  end
  
  context "./optional/*[name()='attribute']" do
    context 'count(/grammar/define/element/optional/attribute/*) > 1' do
      it 'shows not implemented' do
        parse_grammar(%Q{<define name="def_artist-element">
          <element name="artist">
            <optional><attribute name="name"><element1/><element2/></attribute></optional>
            <optional/>
          </element>
        </define>}).xpath("/artist/attributes/name/error/message").text.should == 'Not implemented: more than 1 ./*.'
      end
    end
  end
end