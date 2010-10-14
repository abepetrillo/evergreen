module Evergreen
  class Runner
    class Example
      def initialize(row)
        @row = row
      end

      def passed?
        @row['passed']
      end

      def dot
        if passed? then '.' else 'F' end
      end

      def failure_message
        unless passed?
          msg = []
          msg << "  Failed: #{@row['name']}"
          msg << "    #{@row['message']}"
          msg << "    in #{@row['trace']['fileName']}:#{@row['trace']['lineNumber']}" if @row['trace']
          msg.join("\n")
        end
      end
    end

    class SpecRunner
      attr_reader :runner, :spec

      def initialize(runner, spec)
        @runner = runner
        @spec = spec
      end

      def session
        runner.session
      end

      def io
        runner.io
      end

      def run
        io.puts dots
        io.puts failure_messages
        passed?
      end

      def examples
        @results ||= begin
          session.visit(spec.url)
          session.wait_until(180) { session.evaluate_script('Evergreen.done') }
          JSON.parse(session.evaluate_script('Evergreen.getResults()')).map do |row|
            Example.new(row)
          end
        end
      end

      def passed?
        examples.all? { |example| example.passed? }
      end

      def dots
        examples.map { |example| example.dot }.join
      end

      def failure_messages
        examples.map { |example| example.failure_message }.join("\n\n")
      end
    end

    attr_reader :suite, :io

    def initialize(suite, io=STDOUT)
      @io = io
      @suite = suite
      @spec_results = {}
    end

    def spec_runner(spec)
      SpecRunner.new(self, spec)
    end

    def run
      io.puts dots
      io.puts failure_messages
      passed?
    end

    def examples
      spec_runners.map { |spec_runner| spec_runner.examples }.flatten
    end

    def passed?
      spec_runners.all? { |spec_runner| spec_runner.passed? }
    end

    def dots
      spec_runners.map { |spec_runner| spec_runner.dots }.join
    end

    def failure_messages
      spec_runners.map { |spec_runner| spec_runner.failure_messages }.join("\n\n")
    end

    def session
      @session ||= Capybara::Session.new(suite.driver, suite.application)
    end

  protected

    def spec_runners
      @spec_runners ||= suite.specs.map { |spec| SpecRunner.new(self, spec) }
    end
  end
end
