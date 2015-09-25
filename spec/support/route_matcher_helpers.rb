module Spec
  module Support
    # container for methods used in specs
    module RouteMatcherHelpers
      def self.api
        Class.new(Grape::API) do
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
      end

      def self.mounting_api
        Class.new(Grape::API) do
          mount Spec::Support::RouteMatcherHelpers.api
        end
      end
    end
  end
end
