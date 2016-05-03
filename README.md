[![Circle CI](https://circleci.com/gh/rubakas/cater.svg?style=shield&circle-token=5cab92a48428dd8408acf50bf2982b15af81dfed)](https://circleci.com/gh/rubakas/cater)

# Cater

Cater is a modular implementation of ServiceObject pattern

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cater'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cater

## Usage

```ruby
class MyBusinessBehavior
  # include module
  include ::Cater::Service

  after_call :_log_stuff

  required do
    boolean :parameter
  end

  def call(parameter)
    error! unless parameter
  end

  def _log_stuff
    Rails.logger.fatal("Stuff logged")
  end
end

# Now feel free to invoke .call class method
successful_service = MyBusinessBehavior.call(true)
successful_service.success?
# true
successful_service.error?
# false

error_service =  MyBusinessBehavior.call(false)
error_service.error?
# true
error_service.success?
# false

invalid_service =  MyBusinessBehavior.call()
invalid_service.error?
# true
invalid_service.message
# { "is_one" => ["parameter is required"] }
invalid_service.success?
# false

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Please stick to `git flow` branch convention

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cater. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

