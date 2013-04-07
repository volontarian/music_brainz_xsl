module MusicBrainz
  class Tag
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :count, from: '@count'

    xml_accessor :name, from: 'name'
  end
end
