module MusicBrainz
  class UserTag
include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :name, from: 'name'
  end
end
