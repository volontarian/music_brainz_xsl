require 'spec_helper'

describe 'views/schema.xsl/attributes' do
  include_examples 'views/schema.xsl/value', 'attribute'
  include_examples 'views/schema.xsl/data_type', 'attribute'
end