# Scalingo::ProviderApi

Ruby client for the Scalingo provider API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scalingo-provider_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scalingo-provider_api

## Usage


### Intialization

```ruby
client = Scalingo::ProviderApi::Client.new("user", "password")
```

### Find an app by id

```ruby
app = client.find_app "resource_id"
```

### Send configuration for an addon

```ruby
client.send_config "resource_id", [{name: "TCP_ENDPOINT", value: "tcp://localhost:1234"}]
```

### Provision an addon

```ruby
client.provision "resource_id"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Scalingo/scalingo-provider_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
