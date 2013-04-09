require File.expand_path('../lib/music_brainz_xsl.rb', File.dirname(__FILE__))

file = File.open(File.expand_path('../schema/musicbrainz.xml', File.dirname(__FILE__)), 'w')
file.puts MusicBrainzXsl::Mapper.transform(
  open(
    File.expand_path('../data/musicbrainz_mmd-2.0.rng', File.dirname(__FILE__))
  ).read
)
file.close

puts 'Successfully generated schema/musicbrainz.xml'
