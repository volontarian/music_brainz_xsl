require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'rexml/document'
require 'xml/xslt'

require File.expand_path('../lib/transform.rb', File.dirname(__FILE__))

Dir[File.expand_path('./spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
end

def strip_text(text, remove_empty_lines = true)
  text = text.strip.split("\n").map(&:strip)
  
  text.delete_if{|line| line == '' } if remove_empty_lines
  
  text.join("\n")
end

def strip_xml(xml)
  xml.strip.split("\n").map(&:strip).join('')
end

def parse_grammar(grammar)
  Nokogiri.parse(transform_grammar(grammar))
end

def transform_grammar(grammar)
  transform("<grammar>#{grammar}</grammar>").strip.gsub('<schema>', '').gsub('</schema>', '')
end