require 'open3'

module Evergreen
  class Spec
    attr_reader :name, :suite

    def initialize(suite, name)
      @suite = suite
      @name = name
    end

    def root
      suite.root
    end

    def full_path
      File.join(root, Evergreen.spec_dir, name)
    end

    def read
      if full_path =~ /\.coffee$/
        require 'coffee-script'
        CoffeeScript.compile(File.read(full_path))
      else
        File.read(full_path)
      end
    end
    alias_method :contents, :read

    def url
      "#{suite.mounted_at}/run/#{name}"
    end

    def passed?
      runner.passed?
    end

    def failure_messages
      runner.failure_messages
    end

    def exist?
      File.exist?(full_path)
    end

  protected

    def runner
      @runner ||= suite.runner.spec_runner(self)
    end
  end
end
