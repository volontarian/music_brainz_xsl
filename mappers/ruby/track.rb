module MusicBrainz
  class Track
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :position, from: 'position'
    xml_accessor :number, from: 'number'
    xml_accessor :title, from: 'title'
    xml_accessor :length, from: 'length'

    xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
    xml_accessor :recording, from: 'recording', as: Recording
  end
end
