module MusicBrainz
  class Disc
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'

    xml_accessor :sectors, from: 'sectors'

    xml_accessor :releases, from: 'release-list/release', as: [Release]
  end
end
