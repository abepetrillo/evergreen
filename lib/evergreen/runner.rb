module Evergreen
  class Runner
    attr_reader :spec

    def self.run(root, io=STDOUT)
      runners = Spec.all(root).map { |spec| new(spec) }
      runners.each do |runner|
        if runner.passed?
          io.print '.'
        else
          io.print 'F'
        end
      end
      io.puts ""

      runners.each do |runner|
        io.puts runner.failure_message unless runner.passed?
      end
    end

    def initialize(spec)
      @spec = spec
    end

    def passed?
      failed_examples.empty?
    end

    def failure_message
      failed_examples.map do |row|
        <<-ERROR
  Failed: #{row.name}
      #{row.message}
      in #{row.trace.fileName}:#{row.trace.lineNumber}
        ERROR
      end.join("\n\n")
    end

  protected

    def failed_examples
      results.select { |row| !row.passed }
    end

    def results
      @results ||= begin
        session = Capybara::Session.new(:envjs, Evergreen.application(spec.root))
        session.visit(spec.url)
        session.evaluate_script('jasmine.results')
      end
    end

  end
end




