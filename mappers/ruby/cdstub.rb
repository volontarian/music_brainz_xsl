module MusicBrainz
  class Cdstub
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'

    xml_accessor :title, from: 'title'
    xml_accessor :artist, from: 'artist'
    xml_accessor :barcode, from: 'barcode'
    xml_accessor :comment, from: 'comment'

    xml_accessor :nonmb_tracks, from: 'nonmb-track-list/nonmb-track', as: [NonmbTrack]
  end
end
