require 'spec_helper'

# Encoding: utf-8
describe GrapeApiary::Parameter do
  subject(:parameter) do
    described_class.new(route, name, options)
  end

  let(:name) do
    'foo'
  end

  let(:options) { {} }

  let(:route) do
    double(:route, model_name: 'foo')
  end

  context '#full_name' do
    subject { parameter.full_name }

    context 'when it is a regular route' do
      it { should eql 'foo' }
    end

    context 'when it is a nested property of a hash' do
      let(:name) { 'foo[bar]' }
      let(:route) do
        double(
          :route,
          model_name: 'foo',
          parameters: [
            double(:parameter, name: 'foo', type: Hash)
          ]
        )
      end

      it { should eql 'foo[bar]' }
    end

    context 'when it is a nested property of an Array' do
      let(:name) { 'foo[bar]' }
      let(:route) do
        double(
          :route,
          model_name: 'foo',
          parameters: [
            double(:parameter, name: 'foo', type: Array)
          ]
        )
      end

      it { should eql 'foo[][bar]' }
    end
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

    context 'when it is of type Array' do
      let(:options) { { type: Array } }
      it { should be false }
    end

    context 'when it is of type Hash' do
      let(:options) { { type: Hash } }
      it { should be false }
    end
  end
end
