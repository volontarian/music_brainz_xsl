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