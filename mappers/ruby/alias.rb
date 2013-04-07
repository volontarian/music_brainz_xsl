module MusicBrainz
  class Alias
    include ROXML, ::MusicBrainzXsl::SearchResultMapper
    xml_accessor :locale, from: '@locale'
    xml_accessor :sort_name, from: '@sort-name'
    xml_accessor :type, from: '@type'
    xml_accessor :primary, from: '@primary'
    xml_accessor :begin_date, from: '@begin-date'
    xml_accessor :end_date, from: '@end-date'
  end
end
