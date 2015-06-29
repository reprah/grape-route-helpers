# grape-route-helpers

 Provides named route helpers for Grape APIs, similar to [Rails' route helpers](http://edgeguides.rubyonrails.org/routing.html#path-and-url-helpers).

### Installation

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

### Usage examples

To see which methods correspond to which paths, and which options you can pass them:

```bash
$ rake grape:route_helpers
```

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

# passing in values required to build a path
api_v1_cats_path(id: 1) # => '/api/v1/cats/1.json'

# catch-all paths have helpers
api_v1_anything_path # => '/api/v1/*anything'
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
