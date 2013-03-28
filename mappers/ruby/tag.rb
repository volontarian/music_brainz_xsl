module MusicBrainz
  class Tag
    include ROXML
        
    xml_accessor :count, from: '@count'

    xml_accessor :name, from: 'name'
  end
end
