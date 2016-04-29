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
          r.instance_variable_get(:@options)
        end

        duplicates = all_route_options.select do |o|
          all_route_options.count(o) > 1
        end

        expect(duplicates).to be_empty
        expect(all_route_options.size).to eq(7)
      end
    end
  end
end
