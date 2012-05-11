require 'rubygems'
require 'rake'

require 'opensesame'

namespace :db do
  desc "Set up the appropriate user grants for this project based on config/database.yml"
  task :grant do
    Opensesame.grants_task
  end

  desc "Set up the appropriate user grants for this project based on config/shards.yml and shards in config/database.yml"
  task :grant_shards do
    Opensesame.grants_task(:sharded => true)
  end
end
