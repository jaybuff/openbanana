require "rake"

shared_context "rake" do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { File.expand_path("./lib/openbanana/tasks/#{task_name.split(":").first}.rake") }
  subject         { rake[task_name] }

  before do
    Rake.application = rake
    Rake.application.rake_require(File.expand_path('./lib/openbanana/tasks'))
    Rake::Task.define_task(:environment)
  end
end

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))
require 'openbanana'
