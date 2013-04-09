shared_examples 'schema/partials/value.xsl' do |subject_type|
  context 'unexpected tag in /grammar/define/element/optional/attribute/*[1]' do
    it 'shows not implemented' do
      parse_grammar(%Q{<define name="def_artist-element">
        <element name="artist">
          <optional><#{subject_type} name="name"><element1/></#{subject_type}></optional>
          <optional/>
        </element>
      </define>}).xpath("/artist/#{subject_type}s/name/error/message").text.should == 'Not implemented #3.'
    end
  end
end