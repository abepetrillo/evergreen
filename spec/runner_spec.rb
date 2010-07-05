require 'spec_helper'

describe Evergreen::Runner do
  let(:root) { File.expand_path('fixtures', File.dirname(__FILE__)) }

  context "with passing spec" do
    let(:spec) { Evergreen::Spec.new(root, 'testing') }
    subject { Evergreen::Runner.new(spec) }

    it { should be_passed }
    its(:spec) { should == spec }
    its(:failure_message) { should be_empty }
  end

  context "with failing spec" do
    let(:spec) { Evergreen::Spec.new(root, 'failing') }
    subject { Evergreen::Runner.new(spec) }

    it { should_not be_passed }
    its(:spec) { should == spec }
    its(:failure_message) { should include("Expected 'bar' to equal 'noooooo'") }
  end

  describe '.run' do
    let(:buffer) { StringIO.new }
    before { Evergreen::Runner.run(root, buffer) }

    describe 'the buffer' do
      subject { buffer.rewind; buffer.read }

      it { should include('.F..') }
      it { should include("Expected 'bar' to equal 'noooooo'") }
    end
  end
end
