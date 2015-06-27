module GrapeRouteHelpers
  #
  class Railtie < Rails::Railtie
    rake_tasks do
      files = File.join(File.dirname(__FILE__), '../tasks/*.rake')
      Dir[files].each { |f| load f }
    end
  end
end
