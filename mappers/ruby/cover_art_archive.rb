module MusicBrainz
  class CoverArtArchive
    include ROXML
        
    xml_accessor :artwork, from: 'artwork'
    xml_accessor :count, from: 'count'
    xml_accessor :front, from: 'front'
    xml_accessor :back, from: 'back'
    xml_accessor :darkened, from: 'darkened'
  end
end
