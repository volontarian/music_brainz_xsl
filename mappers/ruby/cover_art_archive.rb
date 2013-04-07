module MusicBrainz
  class CoverArtArchive
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :artwork, from: 'artwork'
    xml_accessor :count, from: 'count'
    xml_accessor :front, from: 'front'
    xml_accessor :back, from: 'back'
    xml_accessor :darkened, from: 'darkened'
  end
end
