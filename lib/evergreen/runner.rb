module Evergreen
  class Runner
    class Example
      def initialize(row)
        @row = row
      end

      def passed?
        @row['passed']
      end

      def message
        unless passed?
          msg = []
          msg << "  Failed: #{@row['name']}"
          msg << "    #{@row['message']}"
          msg << "    in #{@row['trace']['fileName']}:#{@row['trace']['lineNumber']}" if @row['trace']
          msg.join("\n")
        end
      end
    end

    attr_reader :suite

    def initialize(suite)
      @suite = suite
      @spec_results = {}
    end

    def run_spec(spec, io=STDOUT)
      io.puts dots(spec_results(spec))
      io.puts messages(spec_results(spec))
      spec_results(spec).all? { |example| example.passed? }
    end

    def run(io=STDOUT)
      io.puts dots(results)
      io.puts messages(results)
      results.all? { |example| example.passed? }
    end

    def results
      @results ||= suite.specs.map do |spec|
        spec_results(spec)
      end.flatten
    end

    def spec_results(spec)
      @spec_results[spec] ||= begin
        session.visit(spec.url)
        session.wait_until(180) { session.evaluate_script('Evergreen.done') }
        JSON.parse(session.evaluate_script('Evergreen.getResults()')).map do |row|
          Example.new(row)
        end
      end
    end

    def session
      @session ||= Capybara::Session.new(suite.driver, suite.application)
    end

  protected

    def messages(examples)
      examples.map { |e| e.message }.join("\n\n")
    end

    def dots(examples)
      examples.map { |example| if example.passed? then '.' else 'F' end }.join
    end
  end
end
