require "opensesame/version"

module Opensesame
  # Defining this just to make stubbing in rspec easier
  def self.env
    ENV
  end

  def self.load_yml
    YAML.load_file(File.join(RAILS_ROOT, 'config', 'database.yml'))
  end

  def self.config
    config = Opensesame.load_yml
    return config[Rails.env]
  end

  def self.grants
    config = Opensesame.config
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

      grants << "CREATE USER '#{config['username']}'@'%' #{identify_by};"
      grants << "GRANT ALL PRIVILEGES ON #{config['database']}.* TO '#{config['username']}'@'%' WITH GRANT OPTION;"
    end

    return grants
  end
end
