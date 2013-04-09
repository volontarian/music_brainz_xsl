require 'spec_helper'

describe 'schema/partials/value.xsl' do
  context '<text/>' do
    it 'works' do
      transform_grammar(%Q{<define name="def_artist-element">
        <element name="artist">
          <optional><element name="name"><text/></element></optional>
          <optional/>
        </element>
      </define>}).should == strip_xml(%Q{<artist>
        <attributes/>
        <elements><name><type><name>String</name></type></name></elements>
        <refs/>
      </artist>})
    end
  end
end