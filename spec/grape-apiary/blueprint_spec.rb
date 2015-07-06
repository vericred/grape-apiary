require 'spec_helper'

describe GrapeApiary::Blueprint do
  include_context 'configuration'

  context '#groups' do
    subject { described_class.new(api).groups }

    let(:api) do
      Class.new(Grape::API) do
        resource :users do
          get '/' do
          end
        end

        resource :widgets do
          get '/' do
          end
        end
      end
    end

    it 'groups by base-level namespace' do
      expect(subject.length).to eql 2
    end
  end

  context '#resources' do
    subject { described_class.new(SampleApi) }

    let(:unique_routes) { subject.routes.map(&:route_name).uniq }

    let(:included_routes) do
      unique_routes.reject do |name|
        GrapeApiary.config.resource_exclusion.include?(name.to_sym)
      end
    end

    it 'aggregates routes into resources' do
      expect(subject.resources.first).to be_a(GrapeApiary::Resource)
    end

    it 'excluded resources based on configuration' do
      expect(subject.resources.map(&:uri)).to eq(included_routes)
    end
  end
end
