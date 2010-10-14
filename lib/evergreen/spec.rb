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
      File.join(root, 'spec/javascripts', name)
    end

    def read
      if full_path =~ /\.coffee$/
        %x(coffee -p #{full_path})
      else
        File.read(full_path)
      end
    end
    alias_method :contents, :read

    def url
      "/run/#{name}"
    end

    def passed?
      suite.runner.spec_results(self).all? { |example| example.passed? }
    end

    def exist?
      File.exist?(full_path)
    end
  end
end
