module MusicBrainz
  class Release
    include ROXML
        
    xml_accessor :id, from: '@id'

    xml_accessor :title, from: 'title'
    xml_accessor :status, from: 'status'
    xml_accessor :quality, from: 'quality'
    xml_accessor :disambiguation, from: 'disambiguation'
    xml_accessor :packaging, from: 'packaging'
    xml_accessor :language, from: 'language'
    xml_accessor :script, from: 'script'
    xml_accessor :date, from: 'date'
    xml_accessor :country, from: 'country'
    xml_accessor :barcode, from: 'barcode'
    xml_accessor :asin, from: 'asin'

    xml_accessor :annotation, from: 'annotation', as: Annotation
    xml_accessor :artist_credit, from: 'artist-credit/name-credit', as: [NameCredit]
    xml_accessor :release_group, from: 'release-group', as: ReleaseGroup
    xml_accessor :cover_art_archive, from: 'cover-art-archive', as: CoverArtArchive
    xml_accessor :label_infos, from: 'label-info-list/label-info', as: [LabelInfo]
    xml_accessor :mediums, from: 'medium-list/medium', as: [Medium]
    xml_accessor :tags, from: 'tag-list/tag', as: [Tag]
    xml_accessor :user_tags, from: 'user-tag-list/user-tag', as: [UserTag]
    xml_accessor :collections, from: 'collection-list/collection', as: [Collection]
  end
end
