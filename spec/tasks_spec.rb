require 'rubygems'
require 'rake'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')

describe 'Rake Tasks' do
  before :each do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('opensesame/tasks')
    Rake::Task.define_task(:environment)
  end

  describe 'rake db:grant' do
    let(:task) { 'db:grant' }

    before :each do
      YAML.stub(:load_file).and_return([])
    end

    it 'should require :environment to run first' do
      @rake[task].prerequisites.should include("environment")
    end

    it 'should load database.yml' do
      YAML.should_receive(:load_file).with('config/database.yml').and_return({})
      @rake[task].invoke
    end
  end

  after :each do
    @rake[task].reenable
    @rake['environment'].reenable
    @rake = nil
  end
end
