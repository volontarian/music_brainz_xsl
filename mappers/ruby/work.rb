module MusicBrainz
  class Work
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'
    xml_accessor :type, from: '@type'

    xml_accessor :title, from: 'title'
    xml_accessor :language, from: 'language'
    xml_accessor :disambiguation, from: 'disambiguation'
    xml_accessor :iswc, from: 'iswc'
    xml_accessor :user_rating, from: 'user-rating'

    xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
    xml_accessor :iswcs, from: 'iswc-list/iswc', as: []
    xml_accessor :annotation, from: 'annotation', as: Annotation
    xml_accessor :aliases, from: 'alias-list/alias', as: [Alias]
    xml_accessor :relations, from: 'relation-list/relation', as: [Relation]
    xml_accessor :tags, from: 'tag-list/tag', as: [Tag]
    xml_accessor :user_tags, from: 'user-tag-list/user-tag', as: [UserTag]
    xml_accessor :rating, from: 'rating', as: Rating
  end
end
