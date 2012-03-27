require 'rubygems'
require 'rake'

require 'opensesame'

namespace :db do
  task :grant => [:environment] do
    username = ENV['DB_USER'] || 'root'
    password = ENV['DB_PASSWORD'] || ''
    Opensesame.grants.each do |grant|
      puts "mysql --user=#{username} --password=\"#{password}\" -e \"#{grant}\""
    end
  end
end
