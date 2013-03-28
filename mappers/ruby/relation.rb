module MusicBrainz
  class Relation
    include ROXML
        
    xml_accessor :type, from: '@type'
    xml_accessor :type_id, from: '@type-id'

    xml_accessor :target, from: 'target'
    xml_accessor :direction, from: 'direction'
    xml_accessor :begin, from: 'begin'
    xml_accessor :end, from: 'end'
    xml_accessor :ended, from: 'ended'

    xml_accessor :attributes, from: 'attribute-list/attribute', as: [Attribute]
  end
end
