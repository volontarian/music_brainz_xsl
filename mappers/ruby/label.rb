module MusicBrainz
  class Label
    include ROXML
        
    xml_accessor :id, from: '@id'
    xml_accessor :type, from: '@type'

    xml_accessor :name, from: 'name'
    xml_accessor :sort_name, from: 'sort-name'
    xml_accessor :label_code, from: 'label-code'
    xml_accessor :ipi, from: 'ipi'
    xml_accessor :disambiguation, from: 'disambiguation'
    xml_accessor :country, from: 'country'
    xml_accessor :begin, from: 'begin'
    xml_accessor :end, from: 'end'
    xml_accessor :user_rating, from: 'user-rating'

    xml_accessor :ipis, from: 'ipi-list/ipi', as: [Ipi]
    xml_accessor :annotation, from: 'annotation', as: Annotation
    xml_accessor :aliass, from: 'alias-list/alias', as: [Alias]
    xml_accessor :releases, from: 'release-list/release', as: [Release]
    xml_accessor :tags, from: 'tag-list/tag', as: [Tag]
    xml_accessor :user_tags, from: 'user-tag-list/user-tag', as: [UserTag]
    xml_accessor :rating, from: 'rating', as: Rating
  end
end
