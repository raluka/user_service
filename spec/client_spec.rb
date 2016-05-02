require_relative '../client'
# Before run tests here, start service in 'test' mode
# rake db:migrate SINATRA_ENV=test
# ruby service.rb -p 3000 -e test

describe 'client' do
  before(:each) do
    # tell the service client where the service lives by setting a base_uri
    ClientUser.base_uri = 'http://localhost:3000'

    # clear test database
    User.destroy_all

    # create fresh new users
    User.create(
      name: 'john',
      email: 'john@dose.com',
      bio: 'rubyist'
    )
    User.create(
      name: 'jane',
      email: 'jane@dose.com',
      bio: 'forever young'
    )
  end

  it 'gets a user' do
    user = ClientUser.find_by_name('john')
    expect(user['name']).to eq('john')
    expect(user['email']).to eq('john@dose.com')
    expect(user['bio']).to eq('rubyist')
  end

  it 'returns nil for a user not found' do
    expect(ClientUser.find_by_name('gibberish')).to be_nil
  end
end
