require "opensesame/version"
require 'rake'

module Opensesame
  extend Rake::DSL

  # Defining this just to make stubbing in rspec easier
  def self.env
    ENV
  end

  # load config YML file
  def self.load_yml(filename = 'database.yml')
    YAML.load_file(File.join(Rails.root, 'config', filename))
  end

  # read config YML for environment
  def self.config
    config = Opensesame.load_yml
    return config[Rails.env]
  end

  # read config for sharded case using octopus shards.yml
  def self.shard_config
    config = Opensesame.load_yml('shards.yml')
    config = config['octopus'] if config.keys == ['octopus']
    config = config[Rails.env]
    config = config['shards'] if config.keys == ['shards']
    return config
  rescue Errno::ENOENT => e
    puts 'No shards.yml, using shards in database.yml'
    config = Opensesame.load_yml
    return Hash[config.select {|k,v| k.include?(Rails.env) && k != Rails.env}]
  end

  # generate SQL statements for DB creation, permission grant
  def self.grant_for(config)
    grants = []

    unless config['database']
      return nil
    end

    grants << "CREATE DATABASE #{config['database']};"

    if config['username']
      identify_by = ''
      if config['password']
        identify_by = "IDENTIFIED BY '#{config['password']}'"
      end

      unless config['networks']
        grants << "GRANT ALL PRIVILEGES ON #{config['database']}.* TO '#{config['username']}'@'%' #{identify_by};"
      else
        config['networks'].each do |network|
          grants << "GRANT ALL PRIVILEGES ON #{config['database']}.* TO '#{config['username']}'@'#{network}' #{identify_by};"
        end
      end
    end

    return grants
  end

  # run block on all contained hashes which have the key 'database'
  def self.traverse(obj, &block)
    case obj
    when Hash
      if obj['database']
        block.call(obj)
      else
        obj.each {|k,v| traverse(v, &block)}
      end
    when Array
      obj.each {|v| traverse(v, &block)}
    end
  end

  # generate grants
  def self.grants(args = {})
    config = args[:sharded] ? Opensesame.shard_config : Opensesame.config
    grants = []
    Opensesame.traverse(config) do |leaf_config|
      grants += Opensesame.grant_for(leaf_config)
    end
    return grants
  end

  # run task (here for DRY-ness)
  def self.grants_task(args = {})
    username = ENV['DB_USER'] || 'root'
    password = ENV['DB_PASSWORD'] || ''
    host = nil
    if ENV['DB_HOST']
      host = "--host=#{ENV['DB_HOST']}"
    end

    Opensesame.grants(args).each do |grant|
      sh "mysql #{host} --user=#{username} --password=\"#{password}\" -e \"#{grant}\" || true"
    end
  end
end
