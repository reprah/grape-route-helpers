# grape-route-helpers

 Provides named route helpers for Grape APIs, similar to Rails' route helpers.

### Installation

 1.) Add the gem to your Gemfile if you're using Bundler.

```bash
$ bundle install grape-route-helpers
```

Run `gem install grape-route-helpers` if you're not.

2.) Require the gem after you `require 'grape'` in your application setup.

```ruby
require 'grape/route_helpers'
```

### Usage examples

* To see which methods correspond to which paths, and which options you can pass them:

```bash
$ rake grape:route_helpers
```

* Use the methods inside your Grape API actions. Given this example API:

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
    redirect_to api_v1_cats_path
  end
end
```

You'd have the following methods available inside your Grape API actions:

```ruby
# specifying the version when using Grape's "path" versioning strategy
api_v1_ping_path # => '/api/v1/ping'

# specifying the format
api_v1_cats_path(format: 'xml') # => '/api/v1/cats.xml'

# passing in values required to build a path
api_v1_cats_path(id: 1) # => '/api/v1/cats/1'

# catch-all paths have helpers
api_v1_anything_path # => '/api/v1/*anything'
```
