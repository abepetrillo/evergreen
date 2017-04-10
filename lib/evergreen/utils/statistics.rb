require 'CSV'

module Evergreen

  # This class gathers the statistics about the Spec run durations
  # and writes them to a CSV file.
  class Statistics

    def initialize(output_filename)
      @output_filename = output_filename
      clear_output_file
    end

    # Registers the start event of a SPEC.
    def spec_start(spec)
      @spec_start_time = Time.now
      @current_spec = spec
    end

    # Registers the end event of the SPEC.
    def spec_end
      spec_end_time = Time.now
      duration = spec_end_time - spec_start_time
      row = [current_spec.name, duration]

      write_row(row)
    end

    private
    attr_reader :output_filename, :spec_start_time, :current_spec

    def clear_output_file
      File.open(output_filename, 'w') {|file| file.truncate(0) }
      #File.delete(output_filename)
    end

    def write_row(row)
      CSV.open(output_filename, 'a') do |csv|
        csv << row
      end
    end

  end

  # This file ignores serves as a Statistics class in case in which
  # gathering statistics is ignored.!
  # Using of this kind of class makes the logic easier - we don't
  # have to use the IF statement everytime we might gather the stats.
  class EmptyStatistics
    def initialize(output_filename)
    end

    def spec_start(spec)
    end

    def spec_end
    end
  end

end

