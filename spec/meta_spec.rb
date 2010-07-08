require 'spec_helper'

describe Evergreen::Runner do
  subject { Evergreen::Runner.new(spec) }
  let(:root) { File.expand_path('fixtures', File.dirname(__FILE__)) }

  context "with template spec" do
    let(:spec) { Evergreen::Spec.new(root, 'templates_spec.js') }
    it { should pass }
  end
end

