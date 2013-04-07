module MusicBrainz
  class Puid
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'

    xml_accessor :recordings, from: 'recording-list/recording', as: [Recording]
  end
end
