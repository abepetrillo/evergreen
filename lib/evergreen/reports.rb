require 'builder'

# generates reports in junit xml for ci/jenkins
module Evergreen
  module Reports
    def self.filename(spec_result, index)
      File.join(dir, "#{spec_result[:name]}.#{index}.xml")
    end
    
    def self.dir
      ENV['CI_REPORTS'] || File.expand_path("#{Dir.getwd}/reports")
    end
    
    def self.collect_data(suite)
      # open new reporter
      runners = suite.runner.instance_eval('spec_runners')
      result_data = runners.map do |specrunner|
        {
          :name => specrunner.spec.name,
          :passed => specrunner.spec.passed?,
          :results => specrunner.examples.map { |r|
            row = r.instance_variable_get("@row")
            hash = {}
            row.each {|k,v| hash[k] = v}
            hash
          }
        }
      end
    end
    
    def self.find_filename(spec_result)
      index = 0
      while File.exists?(filename(spec_result, index))
        index = index + 1
      end
      filename(spec_result, index)
    end
    
    def self.publish_spec(spec_result)
      File.open(find_filename(spec_result), "w") do |f|
        builder = Builder::XmlMarkup.new(:target => f, :indent => 2, :escape_attrs => true)    
        builder.instruct!

        tests = 0
        failures = 0
        spec_result[:results].each do |result|
          tests = tests + 1
          failures = failures + 1 unless result['passed']
        end
        
        builder.testsuite({:name => spec_result[:name], :tests => tests, :failures => failures}) do
          spec_result[:results].each do |result|
            builder.testcase({'name' => "#{spec_result[:name]} - #{result['name']}"}) do
              unless result['passed']
                builder.failure(:message => result['message']) do
                  builder.text!('Failed: '+result['name']+' '+result['message'])
                  if result['trace']
                    builder.text!(" -> in #{result['trace']['fileName']}:#{result['trace']['lineNumber']}")
                  end
                end
              end
            end
          end
        end
      end
    end
    
    def self.publish!(suite)
      result_data = collect_data(suite)
      
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p(dir)
      
      result_data.each do |spec_result|
        publish_spec(spec_result)
      end
    end
  end
end