module GrapeRouteHelpers
  # class for displaying the path, helper method name,
  # and required arguments for every Grape::Route.
  class RouteDisplayer
    def route_attributes
      Grape::API.decorated_routes.map do |route|
        {
          route_path: route.route_path,
          helper_names: route.helper_names,
          helper_arguments: route.helper_arguments
        }
      end
    end

    def display
      puts 'Path, Helper, Arguments'
      route_attributes.each do |attributes|
        print "#{attributes[:route_path]},"
        print "#{attributes[:helper_names]},"
        print "#{attributes[:helper_arguments]}"
        puts("\n")
      end
    end
  end
end
