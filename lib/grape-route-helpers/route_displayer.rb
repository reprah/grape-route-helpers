module GrapeRouteHelpers
  # class for displaying the path, helper method name,
  # and required arguments for every Grape::Route.
  class RouteDisplayer
    def route_attributes
      Grape::API.decorated_routes.map do |route|
        {
          route_path: route.route_path,
          route_method: route.route_method,
          helper_names: route.helper_names,
          helper_arguments: route.helper_arguments
        }
      end
    end

    def display
      puts("== GRAPE ROUTE HELPERS ==\n\n")
      route_attributes.each do |attributes|
        printf("%s: %s\n", 'Verb', attributes[:route_method])
        printf("%s: %s\n", 'Path', attributes[:route_path])
        printf("%s: %s\n",
               'Helper Method',
               attributes[:helper_names].join(', '))
        printf("%s: %s\n",
               'Arguments',
               attributes[:helper_arguments].join(', '))
        puts("\n")
      end
    end
  end
end
