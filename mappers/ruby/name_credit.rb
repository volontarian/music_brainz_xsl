module MusicBrainz
  class NameCredit < MusicBrainz::Artist

    xml_accessor :joinphrase, from: '../@joinphrase'
  end
end
