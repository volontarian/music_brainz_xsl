require 'rubygems'
require 'bundler/setup'
#require 'music_brainz_xsl'
require 'nokogiri'
#require 'roxml'
require 'rexml/document'
require 'xml/xslt'

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

private

def transform(input)
  xslt = XML::XSLT.new()
  xslt.xml = REXML::Document.new(Nokogiri::XML.parse(input).remove_namespaces!.to_xml)
  xslt.xsl = REXML::Document.new(
    open(File.expand_path('../schema/musicbrainz.xsl', File.dirname(__FILE__))).read
  )
  
  if result = xslt.serve()
    result = result.split("\n") 
  
    # remove <?xml version=\"1.0\"?>
    result.shift
    
    %Q{<schema>#{result.join("\n")}</schema>}   
  else
    ''
  end
end