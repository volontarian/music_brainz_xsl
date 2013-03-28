module MusicBrainz
  class Rating
    include ROXML
        
    xml_accessor :votes_count, from: '@votes-count'
  end
end
