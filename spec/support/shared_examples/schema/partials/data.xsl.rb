shared_examples 'schema/partials/data.xsl' do |subject_type|
  describe 'known data types' do
    context 'without comment' do
      it 'principally works' do
        {
          'String' => ['string', 'anyURI'],
          'Integer' => ['nonNegativeInteger'],
          'Float' => ['float']
        }.each do |type, data_types|
          data_types.each do |data_type|
            transform_grammar(%Q{<define name="def_artist-element">
              <element name="artist">
                <optional><#{subject_type} name="name"><data type="#{data_type}"/></#{subject_type}></optional>
                <optional/>
              </element>
            </define>}).should == strip_xml(%Q{<artist>
              #{subject_type == 'element' ? '<attributes/>' : ''}
              <#{subject_type}s><name><type><name>#{type}</name>#{type == 'String' ? '<comment/>' : ''}</type></name></#{subject_type}s>
              #{subject_type == 'attribute' ? '<elements/>' : ''}
              <refs/>
            </artist>})
          end
        end
      end
    end
    
    context 'with comment' do
      it 'principally works' do
        transform_grammar(%Q{<define name="def_artist-element">
          <element name="artist">
            <optional>
              <#{subject_type} name="name">
                <data type="string">
                  <param name="pattern">abc</param>
                </data>
              </#{subject_type}>
            </optional>
            <optional/>
          </element>
        </define>}).should == strip_xml(%Q{<artist>
          #{subject_type == 'element' ? '<attributes/>' : ''}
          <#{subject_type}s><name><type><name>String</name><comment>abc</comment></type></name></#{subject_type}s>
          #{subject_type == 'attribute' ? '<elements/>' : ''}
          <refs/>
        </artist>})
      end
    end
  end
  
  describe 'unknown data types' do
    it 'shows not implemented' do
      parse_grammar(%Q{<define name="def_artist-element">
        <element name="artist">
          <optional><#{subject_type} name="name"><data type="unknown"/></#{subject_type}></optional>
          <optional/>
        </element>
      </define>}).xpath("/artist/#{subject_type}s/name/error/message").text.should == 'Not implemented: unknown data type.'
    end
  end
end