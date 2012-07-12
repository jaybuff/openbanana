
require 'spec_helper'

describe 'db:grant' do
end

describe Openbanana do
  before :each do
    Rails = double('rails')
    Rails.stub(:root).and_return('dummy_root')
  end

  describe '#load_yml' do
    it 'should load the database.yml file on Rails.root/config' do
      YAML.should_receive(:load_file).with(Rails.root + '/config/database.yml').and_return({})
      Openbanana.load_yml
    end

    it 'should load the shards.yml file on Rails.root/config' do
      YAML.should_receive(:load_file).with(Rails.root + '/config/shards.yml').and_return({})
      Openbanana.load_yml('shards.yml')
    end
  end

  describe '#config' do
    let(:config) do
      { 'database' => 'test_db',
        'username' => 'test_user',
        'password' => 'test_password'}
    end

    context 'with development configuration' do
      before :each do
        Openbanana.should_receive(:load_yml).and_return({'development' => config})
        Rails.stub(:env).and_return('development')
      end

      it 'should return the proper configuration for this environment' do
        result = Openbanana.config
        result.should == config
      end
    end
  end

  describe '#shard_config' do
    let(:config) do
      { 'database' => 'test_db',
        'username' => 'test_user',
        'password' => 'test_password'}
    end

    context 'with development configuration' do
      before :each do
        Openbanana.should_receive(:load_yml).and_return({'octopus' => {'development' => {'shards' => config}}})
        Rails.stub(:env).and_return('development')
      end

      it 'should return the proper configuration for this environment' do
        result = Openbanana.shard_config
        result.should == config
      end
    end
  end

  describe '#grants' do
    before :each do
      Openbanana.should_receive(:config).and_return(config)
    end

    context 'in production' do
      describe 'with networks' do
        let(:config) do
          { 'database' => 'test_db',
            'username' => 'test_user',
            'password' => 'test_password',
            'networks' => ['127.0.0.0/24']}
        end

        it 'should have networks' do
          result = Openbanana.grants
          result.should include("GRANT ALL PRIVILEGES ON test_db.* TO 'test_user'@'127.0.0.0/24' IDENTIFIED BY 'test_password';")
        end
      end
    end

    context 'on shards' do
      describe 'with multiple shards' do
        let(:config) do
          {
            'shard1' => {
              'database' => 'test_db1',
              'username' => 'test_user',
              'password' => 'test_password'
            },
            'shard2' => {
              'database' => 'test_db2',
              'username' => 'test_user',
              'password' => 'test_password'
            }
          }
        end

        it 'should have both shards' do
          result = Openbanana.grants
          result.should include("GRANT ALL PRIVILEGES ON test_db1.* TO 'test_user'@'%' IDENTIFIED BY 'test_password';")
          result.should include("GRANT ALL PRIVILEGES ON test_db2.* TO 'test_user'@'%' IDENTIFIED BY 'test_password';")
        end
      end
    end

    context 'grants should' do
      let(:config) do
        { 'database' => 'test_db',
          'username' => 'test_user',
          'password' => 'test_password'}
      end

      it 'generate a create database call' do
        result = Openbanana.grants
        result.should include('CREATE DATABASE test_db;')
      end

      it 'generate a grant for the user on that database' do
        result = Openbanana.grants
        result.should include("GRANT ALL PRIVILEGES ON test_db.* TO 'test_user'@'%' IDENTIFIED BY 'test_password';")
      end
    end
  end
end


