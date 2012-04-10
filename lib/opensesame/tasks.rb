require 'rubygems'
require 'rake'

require 'opensesame'

namespace :db do
  desc "Set up the apprpriate user grants for this project based on config/database.yml"
  task :grant do
    username = ENV['DB_USER'] || 'root'
    password = ENV['DB_PASSWORD'] || ''
    host = nil
    if ENV['DB_HOST']
      host = "--host=#{ENV['DB_HOST']}"
    end

    Opensesame.grants.each do |grant|
      sh "mysql #{host} --user=#{username} --password=\"#{password}\" -e \"#{grant}\" || true"
    end
  end
end
