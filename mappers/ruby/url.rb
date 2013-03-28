module MusicBrainz
  class Url
    include ROXML
        
    xml_accessor :id, from: '@id'

    xml_accessor :resource, from: 'resource'
  end
end
