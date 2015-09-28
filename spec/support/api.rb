module Spec
  module Support
    # Test API
    class API < Grape::API
      version 'v1'
      prefix 'api'
      format 'json'

      get 'custom_name', as: :my_custom_route_name do
        'hello'
      end

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

      route :any, '*path' do
        'catch-all route'
      end
    end

    # API with more than one version
    class APIWithMultipleVersions < Grape::API
      version %w(beta alpha v1)

      get 'ping' do
        'pong'
      end
    end

    # API with another API mounted inside it
    class MountedAPI < Grape::API
      mount Spec::Support::API
    end

    # API with a version that would be illegal as a method name
    class APIWithIllegalVersion < Grape::API
      version 'beta-1'

      get 'ping' do
        'pong'
      end
    end
  end
end
