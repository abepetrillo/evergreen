require 'spec_helper'

describe Evergreen::Runner do
  subject { Evergreen::Spec.new(root, template) }

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

    context "with slow failing spec" do
      let(:template) { 'slow_spec.coffee' }
      it { should_not pass }
    end
  end
end

