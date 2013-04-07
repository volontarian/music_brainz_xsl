module MusicBrainz
  class Annotation
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :type, from: '@type'

    xml_accessor :entity, from: 'entity'
    xml_accessor :name, from: 'name'
    xml_accessor :text, from: 'text'
  end
end
