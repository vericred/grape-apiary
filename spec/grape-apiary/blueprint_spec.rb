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
end
