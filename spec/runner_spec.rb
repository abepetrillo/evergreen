require 'spec_helper'

describe Evergreen::Runner do
  let(:suite) { Evergreen::Suite.new }
  let(:runner) { Evergreen::Runner.new(buffer) }
  let(:buffer) { StringIO.new }

  describe '#run' do
    before { runner.run }

    describe 'the buffer' do
      subject { buffer.rewind; buffer.read }
      it { is_expected.to include("Expected 'bar' to equal 'noooooo'") }
      it { is_expected.to include("18 examples, 3 failures") }
    end
  end

  describe '#run_spec' do
    let(:spec) { suite.get_spec('failing_spec.js') }
    before { runner.spec_runner(spec).run }

    describe 'the buffer' do
      subject { buffer.rewind; buffer.read }

      it { is_expected.to include('.F') }
      it { is_expected.to include("Expected 'bar' to equal 'noooooo'") }
      it { is_expected.to include("2 examples, 1 failures") }
    end
  end

  describe 'statistics CSV output' do
    let(:statistics_output_file) { 'runner_spec_stat_output.csv' }
    before :each do
      allow(Evergreen).to receive(:statistics_output_file).and_return(statistics_output_file)
      runner.run
    end

    after :each do
      File.delete(statistics_output_file)
    end

    it 'creates a CSV file with statistics' do
      csv = CSV.read(statistics_output_file)
      expected_specs = suite.specs.map { |s| s.name }
      specs = csv.map { |s| s[0] }

      expect(specs).to match_array(expected_specs)
    end
  end

  describe 'statistics class' do
    subject { super().statistics.class }
    let(:output_file) { nil }

    before :each do
      allow(Evergreen).to receive(:statistics_output_file).and_return output_file
    end

    context 'statistics are disabled' do
      it { is_expected.to eq(Evergreen::EmptyStatistics) }
    end
    context 'statistics are enabled' do
      let(:output_file) { 'some_file.csv' }
      it { is_expected.to eq(Evergreen::Statistics) }
    end
  end

end
