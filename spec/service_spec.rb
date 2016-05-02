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
      get '/api/v1/users/john'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes['name']).to eq('john')
    end

    it 'returns a user with an email' do
      get '/api/v1/users/john'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes['email']).to eq('john@dose.com')
    end

    it "doesn't return user's password" do
      get '/api/v1/users/john'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes).to_not have_key('password')
    end

    it 'returns a user with a bio' do
      get '/api/v1/users/john'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes['bio']).to eq('rubyist')
    end

    it "returns 404 for a user that doesn't exist" do
      get '/api/v1/users/foo'
      expect(last_response.status).to be 404
    end
  end

  describe 'POST on /api/v1/users' do
    # TODO: test create user with invalid parameters
    it 'creates a user' do
      post '/api/v1/users', {
        name: 'trotter',
        email: 'no spam',
        password: 'whatever',
        bio: 'southern belle'
      }.to_json
      expect(last_response).to be_ok
      get '/api/v1/users/trotter'
      attributes = JSON.parse(last_response.body)
      expect(attributes['name']).to eq('trotter')
      expect(attributes['email']).to eq('no spam')
      expect(attributes['bio']).to eq('southern belle')
    end
  end

  describe 'PUT on /api/v1/users/:id' do
    it 'updates a user' do
      User.create(
            name: 'ana',
            email: 'ana@email.com',
            password: 'whatever',
            bio: 'rspec master'
      )
      put '/api/v1/users/ana', {
        bio: 'testing freak'
      }.to_json
      expect(last_response).to be_ok
      get '/api/v1/users/ana'
      attributes = JSON.parse(last_response.body)
      expect(attributes['bio']).to eq('testing freak')
    end
  end
end
