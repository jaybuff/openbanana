require 'spec_helper.rb'

describe 'db:grant' do
  include_context 'rake'

  it 'should require :environment' do
    puts subject
    puts subject.prerequisites
    subject.prerequisites.should include('environment')
  end
end


