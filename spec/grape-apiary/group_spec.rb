require 'spec_helper'

describe GrapeApiary::Group do
  subject(:group) { described_class.new(:users, api.routes) }

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

        namespace '/:user_id' do
          resource :widgets do
            get '/' do
            end
          end
        end
      end
    end
  end

  context '#resources' do
    subject { group.resources }

    it 'groups by URL' do
      expect(subject.length).to eql 3
      expect(subject.first.uri).to eql '/users'
      expect(subject.second.uri).to eql '/users/{id}'
      expect(subject.third.uri).to eql '/users/{user_id}/widgets'
    end
  end

  context '#title' do
    subject { group.title }

    it { should eql 'Users' }
  end
end