Orchestrate API for Ruby
========================
[![Build Status](https://travis-ci.org/orchestrate-io/orchestrate-ruby.png?branch=master)](https://travis-ci.org/orchestrate-io/orchestrate-ruby)

Ruby client interface for the [Orchestrate.io](http://orchestrate.io) REST API.

[rDoc Documentation](http://rdoc.info/github/orchestrate-io/orchestrate-ruby/master/frames)

## Getting Started

Provide your API key:

``` ruby
Orchestrate::Configuration.api_key = '8ce391a...'
```

Create a client:

``` ruby
client = Orchestrate::Client.new
```

and start making requests:

``` ruby
client.list(:my_collection)
```

## Swapping out the HTTP backend

This gem uses [Faraday][] for its HTTP needs -- and Faraday allows you to change the underlying HTTP client used.  It defaults to `Net::HTTP` but if you wanted to use [Typhoeus][] or [EventMachine HTTP][em-http], doing so would be easy.  Alternate Faraday backends enable using callbacks or parallel request support.

In your Orchestrate configuration, simply provide a `faraday` key with a block that will be called with the `Faraday::Connection` object.  You may decorate it with middleware or change the adapter as described in the Faraday README.  Examples are below.

You may use Faraday's `test` adapter to stub out calls to the Orchestrate API in your tests.  See `tests/test_helper.rb` and the tests in `tests/orchestrate/api/*_test.rb` for examples.

[Faraday]: https://github.com/lostisland/faraday/
[Typhoeus]: https://github.com/typhoeus/typhoeus#readme
[em-http]: https://github.com/igrigorik/em-http-request#readme

### Parallel HTTP requests

If you're using a Faraday backend that enables parallelization, such as Typhoeus, EM-HTTP-Request, or EM-Synchrony you can use `Orchestrate::Client#in_parallel` to fire off multiple requests at once.  If your Faraday backend does not support this, the method will still work as expected, but Faraday will output a warning to STDERR and the requests will be performed in series.

``` ruby
client = Orchestrate::Client.new

responses = client.in_parallel do |r|
  r[:list] = client.list(:my_collection)
  r[:user] = client.get(:users, current_user_id)
  r[:user_events] = client.list_events(:users, current_user_id, :notices)
end
# will return when all requests have completed

responses[:user] = #<Faraday::Response:0x00...>
```

### Callback Support

If you're using a Faraday backend that enables callbacks, such as EM-HTTP-Request or EM-Synchrony, you may use the callback interface to designate actions to perform when the request completes.

``` ruby
client = Orchestrate::Client.new
response = client.list(:my_collection)
response.finished? # false
response.on_complete do
  # do stuff with the response as normal
end
```

If the Faraday backend adapter does not support callbacks, the block provided will be executed when `Orchestrate::Client#on_complete` is called.


### Using with Typhoeus

Typhoeus is backed by libcurl and enables parallelization.

``` ruby
require 'typhoeus'
require 'typhoeus/adapters/faraday'

Orchestrate.configure do |config|
  config.faraday = {|f| f.adapter :typhoeus }
  config.api_key = "my_api_key"
end
```

### Using with EM-HTTP-Request

EM-HTTP-Request is an HTTP client for Event Machine.  It enables callback support and parallelization.


``` ruby
require 'em-http-request'

Orchestrate.configure do |config|
  config.faraday = {|f| f.adapter :em_http }
  config.api_key = "my_api_key"
end
```

### Using with EM-Syncrony

EM-Synchrony is a collection of utility classes for EventMachine to help untangle evented code.  It enables parallelization.

``` ruby
require 'em-synchrony'

Orchestrate.configure do |config|
  config.faraday = {|f| f.adapter :em_synchrony }
  config.api_key = "my_api_key"
end
```


