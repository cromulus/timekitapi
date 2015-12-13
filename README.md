# TimekitApi

TimekitApi is a client for interacting with Timekit. Duh.

Very much a Work in Progress. It will change, drastically so and probably won't destroy your computer and everything youn hold dear if you try to use it in it's current state, but I can't guarantee it.

Minimally tested. More tests to follow.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'timekitapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install timekitapi

## Usage

Configure it:
```
TimekitApi.config(app_name:'your_app_name',timezone:'UTC')
```

Get yourself a shiny new instance
```
client=TimekitApi::Client.new()
```

Authorize a user:
```
client.auth(email,password)
```

And run with it:
```
client.me
client.set_timezone('EST')
client.get_accounts
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SwedenUnlimited/timekitapi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

