require 'rubygems'
require 'nokogiri'
require 'rexml/document'
require 'xml/xslt'

require File.expand_path('../lib/transform.rb', File.dirname(__FILE__))

file = File.open(File.expand_path('../schema/musicbrainz.xml', File.dirname(__FILE__)), 'w')
file.puts transform(
  open(
    File.expand_path('../schema/musicbrainz_mmd-2.0.rng', File.dirname(__FILE__))
  ).read
)
file.close

puts 'Successfully generated schema/musicbrainz.xml'
