require 'spec_helper'

describe Evergreen::Runner do
  let(:suite) { Evergreen::Suite.new }
  let(:runner) { Evergreen::Runner.new(buffer) }
  let(:buffer) { StringIO.new }

  describe '#run' do
    before { runner.run }

    describe 'the buffer' do
      subject { buffer.rewind; buffer.read }

      it { should include('.F..') }
      it { should include("Expected 'bar' to equal 'noooooo'") }
      it { should include("18 examples, 3 failures") }
    end
  end

  describe '#run_spec' do
    let(:spec) { suite.get_spec('failing_spec.js') }
    before { runner.spec_runner(spec).run }

    describe 'the buffer' do
      subject { buffer.rewind; buffer.read }

      it { should include('.F') }
      it { should include("Expected 'bar' to equal 'noooooo'") }
      it { should include("2 examples, 1 failures") }
    end
  end
end
