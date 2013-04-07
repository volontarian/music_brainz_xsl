module MusicBrainz
  class Relation
include ROXML, ::MusicBrainzXsl::SearchResultMapper

attr_accessor :target_type
    xml_accessor :type, from: '@type'
    xml_accessor :type_id, from: '@type-id'

    xml_accessor :target, from: 'target'
    xml_accessor :direction, from: 'direction'
    xml_accessor :begin, from: 'begin'
    xml_accessor :end, from: 'end'
    xml_accessor :ended, from: 'ended'

    xml_accessor :attributes, from: 'attribute-list/attribute', as: []
    xml_accessor :artist, from: 'artist', as: Artist
    xml_accessor :release, from: 'release', as: Release
    xml_accessor :release_group, from: 'release-group', as: ReleaseGroup
    xml_accessor :recording, from: 'recording', as: Recording
    xml_accessor :label, from: 'label', as: Label
    xml_accessor :work, from: 'work', as: Work
  end
end
