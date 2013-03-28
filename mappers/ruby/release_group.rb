module MusicBrainz
  class ReleaseGroup
    include ROXML
        
    xml_accessor :id, from: '@id'
    xml_accessor :type, from: '@type'

    xml_accessor :title, from: 'title'
    xml_accessor :disambiguation, from: 'disambiguation'
    xml_accessor :first_release_date, from: 'first-release-date'
    xml_accessor :primary_type, from: 'primary-type'
    xml_accessor :secondary_type, from: 'secondary-type'
    xml_accessor :user_rating, from: 'user-rating'

    xml_accessor :annotation, from: 'annotation', as: Annotation
    xml_accessor :artist_credit, from: 'artist-credit/name-credit', as: [NameCredit]
    xml_accessor :releases, from: 'release-list/release', as: [Release]
    xml_accessor :tags, from: 'tag-list/tag', as: [Tag]
    xml_accessor :user_tags, from: 'user-tag-list/user-tag', as: [UserTag]
    xml_accessor :rating, from: 'rating', as: Rating
  end
end
