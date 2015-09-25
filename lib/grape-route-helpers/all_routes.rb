module GrapeRouteHelpers
  # methods to extend Grape::API's behavior so it can get a
  # list of routes from all APIs and decorate them with
  # the DecoratedRoute class
  module AllRoutes
    def decorated_routes
      # memoize so that construction of decorated routes happens once
      @decorated_routes ||= all_routes.map { |r| DecoratedRoute.new(r) }
    end

    def all_routes
      routes = subclasses.flat_map { |s| s.send(:prepare_routes) }
      # delete duplicate routes
      routes.delete_if do |route|
        all_options = routes.map { |r| r.instance_variable_get(:@options) }
        all_options.count(route.instance_variable_get(:@options)) > 1
      end
    end
  end
end
