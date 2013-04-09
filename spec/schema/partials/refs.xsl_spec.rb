require 'spec_helper'

describe 'schema/partials/refs.xsl' do
  context 'list ref' do
    it 'principally works' do
      transform_grammar(%Q{
        <define name="def_release-element">
          <element name="release">
            <optional><ref name="def_medium-list"/></optional>
            <optional/>
          </element>
        </define>
        <define name="def_medium-list">
          <element name="medium-list">
            <ref name="def_list-attributes"/>
            <optional><element name="track-count"><data type="nonNegativeInteger"/></element></optional>
            <zeroOrMore><ref name="def_medium"/></zeroOrMore>
          </element>
        </define>
      }).should == strip_xml(%Q{<release>
        <attributes/>
        <elements/>
        <refs>
          <medium-list><resource><name>medium</name></resource></medium-list>
        </refs>
      </release>})
    end
  end
  
  context 'element from ref with complex element' do
    it 'works' do
      transform_grammar(%Q{
        <define name="def_artist-element">
          <element name="artist">
            <optional><ref name="def_annotation"/></optional>
            <optional/>
          </element>
        </define>
        <define name="def_annotation">
          <element name="annotation">
            <optional><attribute name="type"><text/></attribute></optional>
            <optional/>
          </element>
        </define>
      }).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements/>
        <refs>
          <annotation/>
        </refs>
      </artist>
      <annotation>
        <attributes><type><type><name>String</name></type></type></attributes>
        <elements/>
        <refs/>
      </annotation>})
    end
  end

  context 'zeroOrMore ref' do
    it 'also handle it' do
      transform_grammar(%Q{<define name="def_artist-element">
        <element name="artist">
          <zeroOrMore><ref name="def_relation-list"/></zeroOrMore>
          <optional/>
        </element>
      </define>
      <define name="def_relation-list">
        <element name="relation-list">
          <attribute name="target-type"><data type="anyURI"/></attribute>
          <ref name="def_list-attributes"/>
          <zeroOrMore><ref name="def_relation-element"/></zeroOrMore>
        </element>
      </define>
      <define name="def_relation-element">
        <element name="relation">
          <element name="target"><data type="anyURI"/></element>
          <optional/>
        </element>
      </define>}).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements/>
        <refs>
          <relation-list><resource><name>relation</name></resource></relation-list>
        </refs>
      </artist>
      <relation>
        <attributes/>
        <elements><target><type><name>String</name></type></target></elements>
        <refs/>
      </relation>})
    end
  end
  
  context 'optional choice refs' do
    it 'also handle them' do
      choices = ['release', 'artist']
      
      choices_definitions = choices.map do |choice|
        %Q{<define name="def_#{choice}-element">
          <element name="#{choice}"><optional><element name="name"><text/></element></optional><optional/></element>
        </define>}
      end.join('')
      
      choice_resources = choices.map do |choice|
        %Q{<#{choice}><attributes/><elements><name><type><name>String</name></type></name></elements><refs/></#{choice}>}
      end.join('')
      
      transform_grammar(%Q{<define name="def_relation-element">
        <element name="relation">
          <optional><choice>#{choices.map{|c| "<ref name='def_#{c}-element'/>" }.join('')}</choice></optional>
          <optional/>
        </element>
      </define>
      #{choices_definitions}}).should == strip_xml(%Q{<relation>
        <attributes/>
        <elements/>
        <refs>#{choices.map{|c| "<#{c}/>" }.join('')}</refs>
      </relation>
      #{choice_resources}})
    end
  end
end