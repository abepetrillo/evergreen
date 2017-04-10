require 'spec_helper'
require 'evergreen/utils/statistics'

describe Evergreen::Statistics do
  OUTPUT_FILENAME = 'evergreen_test_stats.csv'

  subject { Evergreen::Statistics.new(OUTPUT_FILENAME) }

  let(:statistics) do
    [
      ['spec_1', 56.0],
      ['spec_2', 17.43],
      ['spec_3', 23.11]
    ]
  end

  def run_spec(spec_name, spec_duration)
    spec = double(name: spec_name)

    start_time = Time.new(2015,3,30, 15, 0, 0)
    allow(Time).to receive(:now).and_return(start_time)
    subject.spec_start(spec)

    end_time = start_time + spec_duration
    allow(Time).to receive(:now).and_return(end_time)
    subject.spec_end
  end

  it 'writes the statistics about the specs correctly to the output file' do
    statistics.each do |name, duration|
      run_spec(name, duration)
    end

    row_number = 0
    CSV.foreach(OUTPUT_FILENAME) do |csv_name, csv_duration|
      name, duration = statistics[row_number]

      expect(csv_name).to eq(name)
      expect(csv_duration).to eq(duration.to_s)

      row_number += 1
    end
  end

  after :all do
    File.delete(OUTPUT_FILENAME)
  end

end

describe Evergreen::EmptyStatistics do
  subject { Evergreen::EmptyStatistics.new('xyz') }

  it 'has all necessary methods' do
    expect(subject).to respond_to(:spec_start)
    expect(subject).to respond_to(:spec_end)
  end
end
