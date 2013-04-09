require 'spec_helper'

describe 'schema/musicbrainz/attributes.xsl' do
  include_examples 'schema/partials/value.xsl', 'attribute'
  include_examples 'schema/partials/data.xsl', 'attribute'
end