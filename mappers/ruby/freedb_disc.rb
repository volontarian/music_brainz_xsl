module MusicBrainz
  class FreedbDisc
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'

    xml_accessor :title, from: 'title'
    xml_accessor :artist, from: 'artist'
    xml_accessor :category, from: 'category'
    xml_accessor :year, from: 'year'

    xml_accessor :nonmb_tracks, from: 'nonmb-track-list/nonmb-track', as: [NonmbTrack]
  end
end
