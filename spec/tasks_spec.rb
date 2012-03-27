
require './lib/opensesame'

describe 'db:grant' do
end

describe Opensesame do
  let(:config) do
    { 'database' => 'test_db',
      'username' => 'test_user',
      'password' => 'test_password'}
  end

  before :each do
    RAILS_ROOT = 'dummy-root'
    Rails = double('rails')
  end

  describe '#load_yml' do
    it 'should load the database.yml file on RAILS_ROOT/config' do
      YAML.should_receive(:load_file).with(RAILS_ROOT + '/config/database.yml').and_return({})
      Opensesame.load_yml
    end
  end

  describe '#config' do
    context 'with development configuration' do
      before :each do
        Opensesame.should_receive(:load_yml).and_return({'development' => config})
        Rails.stub(:env).and_return('development')
      end

      it 'should return the proper configuration for this environment' do
        result = Opensesame.config
        result.should == config
      end
    end
  end

  describe '#grants' do
    before :each do
      Opensesame.should_receive(:config).and_return(config)
    end

    context 'grants should' do
      let(:result) { Opensesame.grants }

      it 'generate a create database call' do
        result.should include('CREATE DATABASE test_db;')
      end

      it 'generate a create user call' do
        result.should include("CREATE USER 'test_user'@'%' IDENTIFIED BY 'test_password';")
      end

      it 'generate a grant for the user on that database' do
        result.should include("GRANT ALL PRIVILEGES ON test_db.* TO 'test_user'@'%' WITH GRANT OPTION;")
      end
    end
  end

  after :each do
    RAILS_ROOT = nil
  end
end


