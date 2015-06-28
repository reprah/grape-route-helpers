require 'grape'
require 'active_support'
require 'active_support/core_ext/class'

require 'grape-route-helpers/decorated_route'
require 'grape-route-helpers/named_route_matcher'
require 'grape-route-helpers/all_routes'
require 'grape-route-helpers/route_displayer'

#
module GrapeRouteHelpers
  require 'grape-route-helpers/railtie' if defined?(Rails)
end

Grape::API.extend GrapeRouteHelpers::AllRoutes
Grape::Endpoint.send(:include, GrapeRouteHelpers::NamedRouteMatcher)
