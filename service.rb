# service.rb - contains the entire service
require 'active_record'
require 'sinatra'
require_relative 'models/user'
require 'logger'

# setting up a logger. levels: DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
log = Logger.new(STDOUT)
log.level == Logger::DEBUG

# setting up the environment
env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = env_arg || ENV['SINATRA_ENV'] || 'development'
log.debug "env: #{env}"

# connecting to database
use ActiveRecord::ConnectionAdapters::ConnectionManagement # close connection to the DDBB properly
databases = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(databases[env])
log.debug "#{databases[env]['database']} database connection established."

#creating a fixture data (only in test mode)
if env == 'test'
  User.destroy_all
  User.create(
        name: 'john',
        email: 'john@dose.com',
        bio: 'rubyist'
  )
  log.debug 'fixture data created in test database.'
end

# HTTP entry points

# get a user by name
get '/api/v1/users/:name' do
  user = User.find_by_name(params[:name])
  if user
    user.to_json
  else
    error 404, { error: 'user not found' }.to_json
  end
end

# create a new user
post '/api/v1/users' do
  begin
    user = User.create(JSON.parse(request.body.read))
    if user.valid?
      user.to_json
    else
      error 400, user.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end
