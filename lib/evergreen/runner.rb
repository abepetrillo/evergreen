module Evergreen
  class Runner
    attr_reader :spec

    def self.run(root, io=STDOUT)
      io.puts "Started"
      passed, failed = 0, 0
      runners = Spec.all(root).map { |spec| new(spec) }
      runners.each do |runner|
        if runner.passed?
          io.print '.'
          passed += 1
        else
          io.print 'F'
          failed += 1
        end
      end
      io.puts ""
      io.puts "#{passed + failed} specs, #{passed} successes, #{failed} failures"

      runners.each do |runner|
        io.puts runner.failure_message unless runner.passed?
      end
      runners.all? { |runner| runner.passed? }
    end

    def initialize(spec)
      @spec = spec
    end

    def name
      spec.name
    end

    def passed?
      failed_examples.empty?
    end

    def failure_message
      failed_examples.map do |row|
        msg = []
        msg << "  Failed: #{row['name']}"
        msg << "    #{row['message']}"
        msg << "    in #{row['trace']['fileName']}:#{row['trace']['lineNumber']}" if row['trace']
        msg.join("\n")
      end.join("\n\n")
    end

  protected

    def failed_examples
      results.select { |row| !row['passed'] }
    end

    def results
      @results ||= begin
        session = Capybara::Session.new(:selenium, Evergreen.application(spec.root, :selenium))
        session.visit(spec.url)
        session.wait_until(180) { session.evaluate_script('Evergreen.done') }
        JSON.parse(session.evaluate_script('Evergreen.getResults()'))
      end
    end

  end
end
