namespace :grape do
  desc 'Print route helper methods.'
  task route_helpers: :environment do
    GrapeRouteHelpers::RouteDisplayer.new.display
  end
end
