#“Service Oriented Design in Ruby and Rails”
##by Paul Dix

Install the gems:

`bundle install`

Migrate the development and test databases:

`rake db:migrate SINATRA_ENV=test`

`rake db:migrate SINATRA_ENV=development`

Run the service specs:

`rspec spec/service_spec.rb`

Run the client library specs. In 2 diferent terminals:

```
ruby service.rb -e test -p 3000
rspec spec/client_spec.rb
```
