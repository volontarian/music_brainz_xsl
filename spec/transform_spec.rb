require 'spec_helper'

describe MusicBrainzXsl::Transform do
  describe '#transform_define' do
    describe 'whole schema' do
      it 'works' do
        path = File.expand_path('../data/musicbrainz_mmd-2.0.rng', File.dirname(__FILE__))
        #puts open(path).read
        file = File.open(File.expand_path('fixtures/temp_transformed_schema.xml', File.dirname(__FILE__)), 'w')
        file.puts described_class.transform_define(open(path).read)
        file.close
        #described_class.transform_define(open(path).read).strip.should == strip_xml(open(File.expand_path('../../../fixtures/xml/music_brainz/transformed_schema.xml', File.dirname(__FILE__))))
      end
    end
    
    describe '/' do
      describe 'multiple defines' do
        it 'works' do
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_artist-element">
                  <element name="artist">
                    <optional><element name="name1"><text/></element></optional>
                    <optional/>
                  </element>
                </define>
                <define name="def_release-element">
                  <element name="release">
                    <optional><element name="name2"><text/></element></optional>
                    <optional/>
                  </element>
                </define>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{
            <artist>
              <attributes/>
              <elements><name1><type><name>String</name></type></name1></elements>
              <refs/>
            </artist>
            <release>
              <attributes/>
              <elements><name2><type><name>String</name></type></name2></elements>
              <refs/>
            </release>
          })
        end
      end
      
      describe 'skip specific define tags' do
        it 'principally works' do
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_metadata-element">
                  <element name="metadata"><optional><attribute name="generator"><data type="anyURI"/></attribute></optional><optional/></element>
                </define>
                <define name="def_anything"><element><anyName><except><nsName ns=""/></except></anyName><zeroOrMore></zeroOrMore></element></define>
                <define name="def_artist-list">
                  <element name="artist-list">
                    <ref name="def_list-attributes"/>
                    <zeroOrMore><ref name="def_artist-element"/></zeroOrMore>
                  </element>
                </define>
                <define name="def_medium-list"/>
                <define name="def_relation-list"/>
                <define name="def_attribute-list"/>
                <define name="def_list-attributes"/>
                <define name="def_ipi-list"/>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{})
        end
      end
    end
    
    describe 'element_with_optionals' do
      context "./optional/*[name()='attribute']" do
        context 'count(/grammar/define/element/optional/attribute/*) > 1' do
          it 'shows not implemented' do
            got = described_class.transform_define(
              %Q{
                <grammar>
                  <define name="def_artist-element">
                    <element name="artist">
                      <optional><attribute name="name"><element1/><element2/></attribute></optional>
                      <optional/>
                    </element>
                  </define>
                </grammar>
              }
            )
            
            Nokogiri.parse(got).xpath("/artist/attributes/name/error/message").text.should == 'Not implemented: more than 1 ./*.'
          end
        end
      end
      
      context "./optional/*[name()='element']" do
        describe 'support nested elements' do
          # will only work for 2 levels as described in this example
          context 'nested optional' do
            it 'works' do
              described_class.transform_define(
                %Q{
                  <grammar>
                    <define name="def_artist-element">
                      <element name="artist">
                        <optional>
                          <element name="parent">
                            <optional><element name="name1"><text/></element></optional>
                            <optional><element name="name2"><text/></element></optional>
                          </element>
                        </optional>
                        <optional/>
                      </element>
                    </define>
                  </grammar>
                }
              ).strip.should == strip_xml(%Q{
                <artist>
                  <attributes/>
                  <elements>
                    <name1><parent>parent</parent><type><name>String</name></type></name1>
                    <name2><parent>parent</parent><type><name>String</name></type></name2>
                  </elements>
                  <refs/>
                </artist>
              })
            end
          end
          
          context 'nested optional zeroOrMore' do
            it 'works' do
              described_class.transform_define(
                %Q{
                  <grammar>
                    <define name="def_artist-element">
                      <element name="artist">
                        <optional>
                          <element name="parent-list">
                            <optional><zeroOrMore><element name="name"><text/></element></zeroOrMore></optional>
                          </element>
                        </optional>
                        <optional/>
                      </element>
                    </define>
                  </grammar>
                }
              ).strip.should == strip_xml(%Q{
                <artist>
                  <attributes/>
                  <elements>
                    <name><parent>parent-list</parent><type><name>String</name></type></name>
                  </elements>
                  <refs/>
                </artist>
              })
            end
          end
        end
        
        describe "./optional/*[name()='ref']" do
          context 'element from ref with 1 element' do
            context 'ref with obligatory or optional element' do
              it 'works' do
                [['', ''], ['<optional>', '</optional>']].each do |tag|
                  described_class.transform_define(
                    %Q{
                      <grammar>
                        <define name="def_artist-element">
                          <element name="artist">
                            <optional><ref name="def_example"/></optional>
                            <optional/>
                          </element>
                        </define>
                        <define name="def_example">
                          <element name="name">#{tag.first}<text/>#{tag.last}</element>
                        </define>
                      </grammar>
                    }
                  ).strip.should == strip_xml(%Q{
                    <artist>
                      <attributes/>
                      <elements>
                        <name><type><name>String</name></type></name>
                      </elements>
                      <refs/>
                    </artist>
                  })
                end
              end
            end
            
            context 'element from ref with complex element' do
              it 'works' do
                described_class.transform_define(
                  %Q{
                    <grammar>
                      <define name="def_artist-element">
                        <element name="artist">
                          <optional><ref name="def_annotation"/></optional>
                          <optional/>
                        </element>
                      </define>
                      <define name="def_annotation">
                        <element name="annotation">
                          <optional><attribute name="type"><text/></attribute></optional>
                          <optional/>
                         </element>
                      </define>
                    </grammar>
                  }
                ).strip.should == strip_xml(%Q{
                  <artist>
                    <attributes/>
                    <elements/>
                    <refs>
                      <annotation/>
                    </refs>
                  </artist>
                  <annotation>
                    <attributes><type><type><name>String</name></type></type></attributes>
                    <elements/>
                    <refs/>
                  </annotation>
                })
              end
            end
          end
          
          context 'list ref' do
            it 'principally works' do
              described_class.transform_define(
                %Q{
                  <grammar>
                    <define name="def_release-element">
                      <element name="release">
                        <optional><ref name="def_medium-list"/></optional>
                        <optional/>
                      </element>
                    </define>
                    <define name="def_medium-list"><element name="medium-list"><ref name="def_list-attributes"/><optional><element name="track-count"><data type="nonNegativeInteger"/></element></optional><zeroOrMore><ref name="def_medium"/></zeroOrMore></element></define>
                  </grammar>
                }
              ).strip.should == strip_xml(%Q{
                <release>
                  <attributes/>
                  <elements/>
                  <refs>
                    <medium-list><resource><name>medium</name></resource></medium-list>
                  </refs>
                </release>
              })
            end
          end
        end
      end
    end
    
    describe 'value' do
      context '<text/>' do
        it 'works' do
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_artist-element">
                  <element name="artist">
                    <optional><element name="name"><text/></element></optional>
                    <optional/>
                  </element>
                </define>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{
            <artist>
              <attributes/>
              <elements><name><type><name>String</name></type></name></elements>
              <refs/>
            </artist>
          })
        end
      end
      
      context 'unexpected tag in /grammar/define/element/optional/attribute/*[1]' do
        it 'shows not implemented' do
          ['attribute', 'element'].each do |subject_type|
            got = described_class.transform_define(
              %Q{
                <grammar>
                  <define name="def_artist-element">
                    <element name="artist">
                      <optional><#{subject_type} name="name"><element1/></#{subject_type}></optional>
                      <optional/>
                    </element>
                  </define>
                </grammar>
              }
            )
            
            Nokogiri.parse(got).xpath("/artist/#{subject_type}s/name/error/message").text.should == 'Not implemented.'
          end
        end
      end
    end

    describe 'ref' do
      context 'def_ipi-list' do
        it 'works' do
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_artist-element"><element name="artist"><optional><ref name="def_ipi-list"/></optional><optional/></element></define>
                <define name="def_ipi-list"><element name="ipi-list"><zeroOrMore><element name="ipi"><ref name="def_ipi"/></element></zeroOrMore></element></define>
                <define name="def_ipi"><data type="string"><param name="pattern">[0-9]{11}</param></data></define>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{
            <artist>
              <attributes/>
              <elements/>
              <refs>
                <ipi-list>
                  <resource>
                    <name>ipi</name>
                    <type><name>String</name><comment>[0-9]{11}</comment></type>
                  </resource>
                </ipi-list>
              </refs>
            </artist>
          })
        end
      end
      
      context 'def_incomplete-date' do
        it 'works' do
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_artist-element">
                  <element name="artist">
                    <optional><element name="name"><ref name="def_incomplete-date"/></element></optional>
                    <optional/>
                  </element>
                </define>
                <define name="def_incomplete-date"/>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{
            <artist>
              <attributes/>
              <elements><name><type><name>IncompleteDate</name></type></name></elements>
              <refs/>
            </artist>
          })
        end
      end
      
      context 'primitive' do
        it 'works' do
          # e.g. data tag
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_artist-element">
                  <element name="artist">
                    <optional><element name="country"><ref name="def_iso-3166"/></element></optional>
                    <optional/>
                  </element>
                </define>
                <define name="def_iso-3166">
                  <data type="string"><param name="pattern">[A-Z]{2}</param></data>
                </define>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{
            <artist>
              <attributes/>
              <elements><country><type><name>String</name><comment>[A-Z]{2}</comment></type></country></elements>
              <refs/>
            </artist>
          })
          
        end
      end
    end
    
    describe 'choice' do
      context 'boolean' do
        it 'works' do
          [
            '<value>true</value><value>false</value>',
            '<value>true</value>', '<value>false</value>'
          ].each do |values|
            described_class.transform_define(
              %Q{
                <grammar>
                  <define name="def_artist-element">
                    <element name="artist">
                      <optional>
                        <element name="boolean">
                          <choice>#{values}</choice>
                        </element>
                      </optional>
                      <optional/>
                    </element>
                  </define>
                </grammar>
              }
            ).strip.should == strip_xml(%Q{
              <artist>
                <attributes/>
                <elements>
                  <boolean><type><name>Boolean</name></type></boolean>
                </elements>
                <refs/>
              </artist>
            })
          end
        end
      end
      
      context 'string' do
        it 'works' do
          described_class.transform_define(
            %Q{
              <grammar>
                <define name="def_artist-element">
                  <element name="artist">
                    <optional>
                      <element name="selection">
                        <choice>
                          <value>1</value><value>2</value>
                        </choice>
                      </element>
                    </optional>
                    <optional/>
                  </element>
                </define>
              </grammar>
            }
          ).strip.should == strip_xml(%Q{
            <artist>
              <attributes/>
              <elements>
                <selection><type><name>String</name><comment>1, 2</comment></type></selection>
              </elements>
              <refs/>
            </artist>
          })
        end
      end
    end
    
    describe 'data_type' do
      context 'known' do
        context 'without comment' do
          it 'principally works' do
            ['attribute', 'element'].each do |subject_type|
              {
                'String' => ['string', 'anyURI'],
                'Integer' => ['nonNegativeInteger'],
                'Float' => ['float']
              }.each do |type, data_types|
                data_types.each do |data_type|
                  described_class.transform_define(
                    %Q{
                      <grammar>
                        <define name="def_artist-element">
                          <element name="artist">
                            <optional><#{subject_type} name="name"><data type="#{data_type}"/></#{subject_type}></optional>
                            <optional/>
                          </element>
                        </define>
                      </grammar>
                    }
                  ).strip.should == strip_xml(%Q{
                    <artist>
                      #{subject_type == 'element' ? '<attributes/>' : ''}
                      <#{subject_type}s><name><type><name>#{type}</name>#{type == 'String' ? '<comment/>' : ''}</type></name></#{subject_type}s>
                      #{subject_type == 'attribute' ? '<elements/>' : ''}
                      <refs/>
                    </artist>
                  })
                end
              end
            end
          end
        end
        
        context 'with comment' do
          it 'principally works' do
            ['attribute', 'element'].each do |subject_type|
              described_class.transform_define(
                %Q{
                  <grammar>
                    <define name="def_artist-element">
                      <element name="artist">
                        <optional>
                          <#{subject_type} name="name">
                            <data type="string">
                              <param name="pattern">abc</param>
                            </data>
                          </#{subject_type}>
                        </optional>
                        <optional/>
                      </element>
                    </define>
                  </grammar>
                }
              ).strip.should == strip_xml(%Q{
                <artist>
                  #{subject_type == 'element' ? '<attributes/>' : ''}
                  <#{subject_type}s><name><type><name>String</name><comment>abc</comment></type></name></#{subject_type}s>
                  #{subject_type == 'attribute' ? '<elements/>' : ''}
                  <refs/>
                </artist>
              })
            end
          end
        end
      end
      
      context 'unknown' do
        it 'shows not implemented' do
          ['attribute', 'element'].each do |subject_type|
            got = described_class.transform_define(
              %Q{
                <grammar>
                  <define name="def_artist-element">
                    <element name="artist">
                      <optional><#{subject_type} name="name"><data type="unknown"/></#{subject_type}></optional>
                      <optional/>
                    </element>
                  </define>
                </grammar>
              }
            )
  
            Nokogiri.parse(got).xpath("/artist/#{subject_type}s/name/error/message").text.should == 'Not implemented: unknown data type.'
          end
        end
      end
    end
  end
  
  def strip_xml(xml)
    xml.strip.split("\n").map(&:strip).join('')
  end
end