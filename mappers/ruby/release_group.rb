module MusicBrainz
  class ReleaseGroup
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'
    xml_accessor :type, from: '@type'

    xml_accessor :title, from: 'title'
    xml_accessor :disambiguation, from: 'disambiguation'
    xml_accessor :first_release_date, from: 'first-release-date'
    xml_accessor :primary_type, from: 'primary-type'
    xml_accessor :secondary_types, from: 'secondary-type-list/secondary-type', as: []
    xml_accessor :user_rating, from: 'user-rating'

    xml_accessor :annotation, from: 'annotation', as: Annotation
    xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
    xml_accessor :releases, from: 'release-list/release', as: [Release]
    xml_accessor :relations, from: 'relation-list/relation', as: [Relation]
    xml_accessor :tags, from: 'tag-list/tag', as: [Tag]
    xml_accessor :user_tags, from: 'user-tag-list/user-tag', as: [UserTag]
    xml_accessor :rating, from: 'rating', as: Rating
  end
end
