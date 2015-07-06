require 'spec_helper'

describe GrapeApiary::Route do
  include_context 'configuration'

  let(:routes) { GrapeApiary::Blueprint.new(SampleApi).routes }

  subject(:route) { routes.first }

  it 'adds a name helper to routes' do
    expect(subject.route_name).to eq('widgets')
  end

  context '#visible_parameters' do
    let(:api) do
      Class.new(Grape::API) do
        resource :users do
          params do
            requires :foo
            optional :bar
          end
          get ':id' do
          end

          params do
            requires :baz
            optional :qux
          end
          post ':id' do
          end
        end
      end
    end

    context 'on a GET' do
      subject { described_class.new(nil, api.routes.first).visible_parameters }

      it 'shows all parameters' do
        expect(subject.length).to eql 3
      end
    end

    context 'on a POSt' do
      subject { described_class.new(nil, api.routes.last).visible_parameters }

      it 'shows only ID' do
        expect(subject.length).to eql 1
        expect(subject.first.full_name).to eql 'id'
      end
    end
  end
end
