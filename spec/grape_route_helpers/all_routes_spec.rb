require 'spec_helper'

describe GrapeRouteHelpers::AllRoutes do
  Grape::API.extend described_class

  describe '#all_routes' do
    context 'when API is mounted within another API' do
      let(:mounting_api) { Spec::Support::MountedAPI }

      it 'does not include the same route twice' do
        mounting_api

        # A route is unique if no other route shares the same set of options
        all_route_options = Grape::API.all_routes.map do |r|
          r.instance_variable_get(:@options).merge(path: r.path)
        end

        duplicates = all_route_options.select do |o|
          all_route_options.count(o) > 1
        end

        expect(duplicates).to be_empty
      end
    end

    context 'when there are multiple POST routes with the same namespace in the same API' do
      it 'returns all POST routes' do
        expected_routes = Spec::Support::MultiplePostsAPI.routes.map(&:path)

        all_routes = Grape::API.all_routes
        expect(all_routes.map(&:path)).to include(*expected_routes)
      end
    end
  end
end
