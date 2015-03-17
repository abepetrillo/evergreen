require 'spec_helper'

describe Evergreen::Runner do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Spec.new(suite, template) }

  context "with standard setup" do
    before { Evergreen.root = File.expand_path('suite1', File.dirname(__FILE__)) }

    context "with transactions spec" do
      let(:template) { 'transactions_spec.js' }
      it { is_expected.to pass }
    end

    context "with spec helper" do
      let(:template) { 'with_helper_spec.js' }
      it { is_expected.to pass }
    end

    context "with template spec" do
      let(:template) { 'templates_spec.js' }
      it { is_expected.to pass }
    end

    context "invalid coffee" do
      let(:template) { 'invalid_coffee_spec.coffee' }
      it { is_expected.not_to pass }
    end

    context "with slow failing spec" do
      let(:template) { 'slow_spec.coffee' }
      it { is_expected.not_to pass }
    end
  end

  context "with modified setup" do
    before { Evergreen.root = File.expand_path('suite2', File.dirname(__FILE__)) }

    context "with awesome spec" do
      let(:template) { 'awesome_spec.js' }
      it { is_expected.to pass }
    end

    context "with failing spec" do
      let(:template) { 'failing_spec.js' }
      it { is_expected.not_to pass }
    end
  end

  context 'when noConflict is called via JS' do
    before { Evergreen.root = File.expand_path('suite3', File.dirname(__FILE__)) }
    let(:template) { 'awesome_spec.js' }
    it 'does not over-ride existing methods in window' do
      expect(subject).to pass
    end

    context 'and not using the Evergreen namespace' do
      let(:template) { 'failing_spec.js' }
      it 'fails' do
        expect(subject).to_not pass
      end
    end
  end
end
