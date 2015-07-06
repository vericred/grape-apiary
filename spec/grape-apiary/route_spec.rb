require 'spec_helper'

describe GrapeApiary::Route do
  include_context 'configuration'

  let(:routes) { GrapeApiary::Blueprint.new(SampleApi).routes }

  subject(:route) { routes.first }

  it 'adds a name helper to routes' do
    expect(subject.route_name).to eq('widgets')
  end

  it 'adds a path helper without format' do
    expect(subject.route_path_without_format).to eq('/widgets')
  end

  it 'adds a type helper' do
    expect(subject.route_type).to eq('collection')
  end

  context '#route_name' do
    let(:api) do
      Class.new(Grape::API) do
        resource :users do
          get '/' do
          end

          post '/' do
          end

          get '/:id' do
          end

          put '/:id' do
          end
        end
      end
    end

    xit 'groups the route by namespace' do
      expect(described_class.route_name(api.routes.first)).to eql('users')
      expect(described_class.route_name(api.routes.second)).to eql('users')
      expect(described_class.route_name(api.routes.third)).to eql(
        '/users/{id}'
      )
      expect(described_class.route_name(api.routes.fourth)).to eql(
        '/users/{id}'
      )
    end
  end


  context '#response_descriptions' do
    subject { route.response_descriptions.first }

    it 'defaults to 200 and the name of the resource' do
      expect(subject.entity_name).to eql 'Widgets'
      expect(subject.http_code).to eql 200
    end
  end
end
