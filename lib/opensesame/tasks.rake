require 'rubygems'
require 'rake'

namespace :db do
  task :grant => [:environment] do
    dbinfo = YAML.load_file('config/database.yml')
  end
end
