ENV['SINATRA_ENV'] = 'test'

require File.dirname(__FILE__) + '/../service'
require 'rspec'
require 'rack/test'

# set :environment, :test
# Test::Unit::TestCase.send :include, Rack::Test::Methods

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

describe 'service' do
  before(:each) do
    User.delete_all
  end

  describe 'GET on /api/v1/users/:id' do
    before(:each) do
      User.create(
        name: 'john',
        email: 'john@dose.com',
        password: 'strongpass',
        bio: 'rubyist'
      )
    end

    it 'returns a user by name' do
      get '/api/v1/users/paul'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)['user']
      expect(attributes['name']).to eq('john')
    end
  end
end
