# grape-route-helpers

[![Build Status](https://travis-ci.org/reprah/grape-route-helpers.svg)](https://travis-ci.org/reprah/grape-route-helpers)

Provides named route helpers for Grape APIs, similar to [Rails' route helpers](http://edgeguides.rubyonrails.org/routing.html#path-and-url-helpers).

### Installation

#### Compatibility with Grape

If you're using grape 0.16.0 or higher, you'll need version 2.0.0 or higher of grape-route-helpers.

#### Rails

 1.) Add the gem to your Gemfile.

```bash
$ bundle install grape-route-helpers
```

#### Sinatra/Rack

1.) Add the gem to your Gemfile if you're using Bundler.

If you're not using Bundler to install/manage dependencies:

```bash
$ gem install grape-route-helpers
```

```ruby
# environment setup file
require 'grape'
require 'grape/route_helpers'
```

2.) Write a rake task called `:environment` that loads the application's environment first. This gem's tasks are dependent on it. You could put this in the root of your project directory:

```ruby
# Rakefile

require 'rake'
require 'bundler'
Bundler.setup
require 'grape-route-helpers'
require 'grape-route-helpers/tasks'

desc 'load the Sinatra environment.'
task :environment do
  require File.expand_path('your_app_file', File.dirname(__FILE__))
end
```

### Usage

#### List All Helper Names

To see which methods correspond to which paths, and which options you can pass them:

```bash
# In your API root directory, at the command line
$ rake grape:route_helpers
```

#### Use Helpers in IRB/Pry

You can use helper methods in your REPL session by including a module:

```ruby
[1] pry(main)> include GrapeRouteHelpers::NamedRouteMatcher
```
#### Use Helpers in Your API

Use the methods inside your Grape API actions. Given this example API:

```ruby
class ExampleAPI < Grape::API
  version 'v1'
  prefix 'api'
  format 'json'

  get 'ping' do
    'pong'
  end

  resource :cats do
    get '/' do
      %w(cats cats cats)
    end

    route_param :id do
      get do
        'cat'
      end
    end
  end

  route :any, '*anything' do
    redirect api_v1_cats_path
  end
end
```

You'd have the following methods available inside your Grape API actions:

```ruby
# specifying the version when using Grape's "path" versioning strategy
api_v1_ping_path # => '/api/v1/ping.json'

# specifying the format
api_v1_cats_path(format: '.xml') # => '/api/v1/cats.xml'

# adding a query string
api_v1_cats_path(params: { sort_by: :age }) # => '/api/v1/cats?sort_by=age'

# passing in values required to build a path
api_v1_cats_path(id: 1) # => '/api/v1/cats/1.json'

# catch-all paths have helpers
api_v1_anything_path # => '/api/v1/*anything'
```

#### Custom Helper Names

If you want to assign a custom helper name to a route, pass the `:as` option when creating your route in your API:

```ruby
class Base < Grape::API
  get 'ping', as: 'is_the_server_running'
    'pong'
  end
end
```

This results in creating a helper called `is_the_server_running_path`.

#### Testing

You can use route helpers in your API tests by including the `GrapeRouteHelpers::NamedRouteMatcher` module inside your specs. Here's an example:

```ruby
require 'spec_helper'

describe Api::Base do
  include GrapeRouteHelpers::NamedRouteMatcher

  describe 'GET /ping' do
    it 'returns a 200 OK' do
      get api_v2_ping_path
      expect(response.status).to be(200)
    end
  end
end
```

### Contributing

1.) Fork it

2.) Create your feature branch `(git checkout -b my-new-feature)`

3.) Write specs for your feature

4.) Commit your changes `(git commit -am 'Add some feature')`

5.) Push to the branch `(git push origin my-new-feature)`

6.) Create a new pull request

### License

See LICENSE
