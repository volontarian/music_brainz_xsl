module MusicBrainz
  class Medium
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :title, from: 'title'
    xml_accessor :position, from: 'position'
    xml_accessor :format, from: 'format'

    xml_accessor :discs, from: 'disc-list/disc', as: [Disc]
    xml_accessor :tracks, from: 'track-list/track', as: [Track]
  end
end
