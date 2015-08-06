require 'spec_helper'

# Encoding: utf-8
describe GrapeApiary::Parameter do
  subject(:parameter) do
    described_class.new(
      double(:route, model_name: 'foo'),
      'foo',
      options
    )
  end

  context '#visible?' do
    subject { parameter.visible? }
    context 'when hidden is true' do
      let(:options) { { documentation: { hidden: true } } }

      it { should be false }
    end

    context 'when hidden is false' do
      let(:options) { { documentation: { hidden: false } } }

      it { should be true }
    end

    context 'when hidden is blank' do
      let(:options) { { } }

      it { should be true }
    end
  end
end
