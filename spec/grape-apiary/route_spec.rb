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

  context '#response_descriptions' do
    subject { route.response_descriptions.first }

    it 'defaults to 200 and the name of the resource' do
      expect(subject.entity_name).to eql 'Widgets'
      expect(subject.http_code).to eql 200
    end
  end
end
