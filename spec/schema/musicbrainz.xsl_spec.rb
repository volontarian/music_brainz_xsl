require 'spec_helper'

describe 'schema/musicbrainz.xsl/' do
  describe 'whole schema' do
    it 'looks like generated one' do
      strip_xml(
        transform(
          open(
            File.expand_path('../../schema/musicbrainz_mmd-2.0.rng', File.dirname(__FILE__))
          ).read
        )
      ).should == strip_xml(
        open(
          File.expand_path('../../schema/musicbrainz.xml', File.dirname(__FILE__))
        ).read
      )
    end
  end
    
  describe 'multiple defines' do
    it 'works' do
      transform_grammar(%Q{<define name="def_artist-element">
        <element name="artist">
          <optional><element name="name1"><text/></element></optional>
          <optional/>
        </element>
      </define>
      <define name="def_release-element">
        <element name="release">
          <optional><element name="name2"><text/></element></optional>
          <optional/>
        </element>
      </define>}).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements><name1><type><name>String</name></type></name1></elements>
        <refs/>
      </artist>
      <release>
        <attributes/>
        <elements><name2><type><name>String</name></type></name2></elements>
        <refs/>
      </release>})
    end
  end
  
  describe 'skip specific define tags' do
    it 'principally works' do
      names = ['def_medium-list', 'def_relation-list', 'def_attribute-list', 'def_list-attributes', 'def_ipi-list']
      
      transform_grammar(%Q{<define name="def_metadata-element">
        <element name="metadata"><optional><attribute name="generator"><data type="anyURI"/></attribute></optional><optional/></element>
      </define>
      <define name="def_anything"><element><anyName><except><nsName ns=""/></except></anyName><zeroOrMore></zeroOrMore></element></define>
      <define name="def_artist-list">
        <element name="artist-list">
          <ref name="def_list-attributes"/>
          <zeroOrMore><ref name="def_artist-element"/></zeroOrMore>
        </element>
      </define>
      #{names.map{|name| '<define name="' + name + '">
        <element name="' + name + '">
          <optional><element name="name"><text/></element></optional>
          <optional/>
        </element>
      </define>' }.join('')}}).should == strip_xml(%Q{})
    end
  end
end