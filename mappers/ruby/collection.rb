module MusicBrainz
  class Collection
    include ROXML
        
    xml_accessor :id, from: '@id'

    xml_accessor :name, from: 'name'
    xml_accessor :editor, from: 'editor'

    xml_accessor :releases, from: 'release-list/release', as: [Release]
  end
end
