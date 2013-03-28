module MusicBrainz
  class Isrc
    include ROXML
        
    xml_accessor :id, from: '@id'

    xml_accessor :recordings, from: 'recording-list/recording', as: [Recording]
  end
end
