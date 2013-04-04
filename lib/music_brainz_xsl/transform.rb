module MusicBrainzXsl
  class Transform
    def self.transform_define(input)
      input = Nokogiri::XML.parse(input).remove_namespaces!.to_xml
      path = File.expand_path('../../templates/schema.xsl', File.dirname(__FILE__))
      transform(input, open(path).read)
    end
    
    private
    
    def self.transform(xml_body, xslt_body)
      xslt = XML::XSLT.new()
  
      xslt.xml = REXML::Document.new(xml_body)
      xslt.xsl = REXML::Document.new(xslt_body)
      
      result = xslt.serve()
      
      if result
        result = result.split("\n") 
      
        # remove <?xml version=\"1.0\"?>
        result.shift
        
        result.join("\n")   
      else
        ''
      end
    end
  end
end