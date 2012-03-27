require 'rubygems'
require 'rake'

require 'opensesame'

namespace :db do
  task :grant => [:environment] do
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
