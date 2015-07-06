require 'spec_helper'

describe GrapeApiary::Resource do
  include_context 'configuration'

  subject(:resource) { GrapeApiary::Resource.new('/foos/{id}', []) }

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
      let(:resource)  { blueprint.resources.find { |r| r.name == 'Users' } }
      it { should be true }
    end
  end

  context '#header' do
    subject { described_class.new(uri, api.routes).header}

    context 'with several parameters' do
      let(:uri) { '/users' }

      let(:api) do
        Class.new(Grape::API) do
          resource :users do
            params do
              requires :foo
              optional :bar
              optional :baz
            end
            get '/' do
            end

            params do
              requires :user, type: Hash do
                requires :name, type: String
                optional :qux, default: 'blah'
              end
            end
            post '/' do
            end
          end
        end
      end

      it { should eql 'Users [/users{?bar,baz,foo}]' }
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

  context '#title' do
    subject { described_class.new(uri, []).title }

    context 'with a singular route' do
      let(:uri) { '/users/{id}' }

      it 'is the singular of the root' do
        expect(subject).to eql 'User'
      end
    end

    context 'with a list route' do
      let(:uri) { '/users' }

      it 'is the plural of the root' do
        expect(subject).to eql 'Users'
      end

    end

  end

end
