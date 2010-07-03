module Evergreen
  class Spec

    def self.all(root)
      Dir.glob(File.join(root, 'spec/javascripts', '*_spec.js')).map do |path|
        new(root, File.basename(path).sub(/_spec\.js$/, ''))
      end
    end

    attr_reader :name, :root

    def initialize(root, name)
      @root = root
      @name = name
    end

    def path
      File.join(root, 'spec/javascripts', name + '_spec.js')
    end

    def read
      File.read(path)
    end

    def url
      "/run/#{name}"
    end

    def passed?
      run unless has_run?
      results.all? { |row| row.passed }
    end

    def failure_message
      run unless has_run?
      results.each do |row|
        puts "Failed: #{row.name}"
        puts "    #{row.message}"
        puts "    in #{row.trace.fileName}:#{row.trace.lineNumber}"
        puts ""
        puts ""
      end
    end

  protected

    def run
      session.visit(url)
      @results = session.evaluate_script('jasmine.results')
    end

    def has_run?
      @results
    end

    def session
      @session ||= Capybara::Session.new(:envjs, Evergreen.applications(root))
    end
  end
end
