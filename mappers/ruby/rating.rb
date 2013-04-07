module MusicBrainz
  class Rating
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :votes_count, from: '@votes-count'
  end
end
