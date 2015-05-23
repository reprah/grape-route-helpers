namespace :grape do
  desc 'Print route helper methods.'
  task routes: :environment do
    GrapeRouteHelpers::RouteDisplayer.new.display
  end
end
