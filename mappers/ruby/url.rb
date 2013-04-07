module MusicBrainz
  class Url
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'

    xml_accessor :resource, from: 'resource'

    xml_accessor :relations, from: 'relation-list/relation', as: [Relation]
  end
end
