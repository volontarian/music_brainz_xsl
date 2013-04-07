module MusicBrainz
  class NonmbTrack
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :title, from: 'title'
    xml_accessor :artist, from: 'artist'
    xml_accessor :length, from: 'length'
  end
end
