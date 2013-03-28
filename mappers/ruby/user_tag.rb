module MusicBrainz
  class UserTag
    include ROXML
        
    xml_accessor :name, from: 'name'
  end
end
