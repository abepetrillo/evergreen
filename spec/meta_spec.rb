require 'spec_helper'

describe Evergreen::Runner do
  subject { Evergreen::Runner.new(spec) }
  let(:spec) { Evergreen::Spec.new(root, template) }

  context "with standard setup" do
    let(:root) { File.expand_path('suite1', File.dirname(__FILE__)) }

    context "with transactions spec" do
      let(:template) { 'transactions_spec.js' }
      it { should pass }
    end

    context "with spec helper" do
      let(:template) { 'with_helper_spec.js' }
      it { should pass }
    end

    context "with template spec" do
      let(:template) { 'templates_spec.js' }
      it { should pass }
    end
  end
end

