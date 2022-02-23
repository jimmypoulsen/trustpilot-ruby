# Trustpilot

This is a basic integration to [TrustPilot's API](https://developers.trustpilot.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trustpilot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trustpilot

## Configuration

There are a few settings that have to be set globally:

```ruby
# In Rails, you could put this in config/initializers/trustpilot.rb
Trustpilot.redis = Redis.new( url: REDIS_URL )

# Required
Trustpilot.api_key = MY_API_KEY
Trustpilot.api_secret = MY_API_SECRET
Trustpilot.api_email = MY_API_EMAIL
Trustpilot.api_password = MY_API_PASSWORD

# Optional
Trustpilot.default_business_unit_id = MY_DEFAULT_BUSINESS_UNIT_ID
```

**Important Note:** This gem requires Redis to work. It uses a Redis server to store access tokens.

## Debugging

HTTP requests can be logged to `$stdout` by setting:

```ruby
Trustpilot.debug = true
```

## Usage

### Invitations API

If you set your business unit id globally, you can do:

```ruby
api = Trustpilot::Invitation.new
api.service_review_link(
  "locationId": "ABC123",
  "referenceId": "inv00001",
  "email": "federico@goldbelly.com",
  "name": "Fede",
  "locale": "en-US",
  "tags": [
    "tag1",
    "tag2"
  ],
  "redirectUri": "https://goldbelly.com"
)

# Check TrustPilot's API docs for required and optional parameters.
```

You can also specify your business unit id, for example:

```ruby
api = Trustpilot::Invitation.new "my_business_unit_id"
api.service_review_link(
  "locationId": "ABC123",
  "referenceId": "inv00001",
  "email": "federico@goldbelly.com",
  "name": "Fede",
  "locale": "en-US",
  "tags": [
    "tag1",
    "tag2"
  ],
  "redirectUri": "https://goldbelly.com"
)

# Check TrustPilot's API docs for required and optional parameters.
```

## TODO
- Implement missing APIs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Test settings

Make sure you create a file called `spec/settings.yml` with your API configuration values. You can copy `spec/settings.example.yml` and replace the values.

Unfortunately, at the time of writing this README, TrustPilot does not provide a test environment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldbely/trustpilot-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Trustpilot project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/goldbely/trustpilot-ruby/blob/master/CODE_OF_CONDUCT.md).
