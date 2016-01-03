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
  
  def serve(parameter)
    error! unless parameter
  end
end

# Now feel free to invoke .serve class method
successful_service = MyBusinessBehavior.serve(true)
successful_service.success?
# true
successful_service.error?
# false

error_service =  MyBusinessBehavior.serve(false)
error_service.error?
# true
error_service.success?
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

