require 'spec_helper'

describe GrapeApiary::Resource do
  include_context 'configuration'

  subject(:resource) { GrapeApiary::Resource.new('foo', []) }

  context '#header' do
    subject { GrapeApiary::Blueprint.new(SampleApi).resources.first.header }

    it 'includes query parameters'
  end

  context 'sample' do
    it 'request generation is delegated to a generator' do
      expect(subject.sample_generator).to receive(:request)

      subject.sample_request
    end

    it 'response generation is delegated to a generator' do
      expect(subject.sample_generator).to receive(:response)

      subject.sample_response(
        GrapeApiary::Route.new(resource, Grape::Route.new)
      )
    end
  end

  context 'has_model?' do
    subject { resource.has_model? }
    let(:blueprint) { GrapeApiary::Blueprint.new(SampleApi) }

    context 'when there is an entity' do
      let(:resource)  { blueprint.resources.find { |r| r.key == 'users' } }
      it { should be true }
    end

    context 'when there is not an entity' do
      let(:resource)  { blueprint.resources.find { |r| r.key == 'widgets' } }
      it { should be false }
    end
  end

  context 'model_example' do
    subject { resource.model_example }
    let(:blueprint) { GrapeApiary::Blueprint.new(SampleApi) }

    context 'when generating the model example' do
      let(:resource)  { blueprint.resources.find { |r| r.key == 'users' } }
      xit 'should be valid json' do
        expect(JSON.parse(subject)).to be_a(Hash);

        user = JSON.parse(subject)['user']

        expect(user).to have_key('id')
        expect(user['is_admin']).to eql false
      end
    end

  end

end
