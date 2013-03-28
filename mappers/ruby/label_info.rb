module MusicBrainz
  class LabelInfo
    include ROXML
        
    xml_accessor :catalog_number, from: 'catalog-number'

    xml_accessor :label, from: 'label', as: Label
  end
end
