module MusicBrainz
  class Track
    include ROXML
        
    xml_accessor :position, from: 'position'
    xml_accessor :number, from: 'number'
    xml_accessor :title, from: 'title'
    xml_accessor :length, from: 'length'

    xml_accessor :artist_credit, from: 'artist-credit/name-credit', as: [NameCredit]
    xml_accessor :recording, from: 'recording', as: Recording
  end
end
