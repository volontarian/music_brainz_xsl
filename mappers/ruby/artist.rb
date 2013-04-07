module MusicBrainz
  class Artist
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :id, from: '@id'
    xml_accessor :type, from: '@type'

    xml_accessor :name, from: 'name'
    xml_accessor :sort_name, from: 'sort-name'
    xml_accessor :gender, from: 'gender'
    xml_accessor :country, from: 'country'
    xml_accessor :disambiguation, from: 'disambiguation'
    xml_accessor :ipi, from: 'ipi'
    xml_accessor :begin, from: 'life-span/begin'
    xml_accessor :end, from: 'life-span/end'
    xml_accessor :user_rating, from: 'user-rating'

    xml_accessor :annotation, from: 'annotation', as: Annotation
    xml_accessor :ipis, from: 'ipi-list/ipi', as: []
    xml_accessor :aliases, from: 'alias-list/alias', as: [Alias]
    xml_accessor :recordings, from: 'recording-list/recording', as: [Recording]
    xml_accessor :releases, from: 'release-list/release', as: [Release]
    xml_accessor :release_groups, from: 'release-group-list/release-group', as: [ReleaseGroup]
    xml_accessor :labels, from: 'label-list/label', as: [Label]
    xml_accessor :works, from: 'work-list/work', as: [Work]
    xml_accessor :relations, from: 'relation-list/relation', as: [Relation]
    xml_accessor :tags, from: 'tag-list/tag', as: [Tag]
    xml_accessor :user_tags, from: 'user-tag-list/user-tag', as: [UserTag]
    xml_accessor :rating, from: 'rating', as: Rating
  end
end
