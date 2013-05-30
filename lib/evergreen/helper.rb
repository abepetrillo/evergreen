module Evergreen
  class Helper

    attr_reader :name, :suite

    def initialize(suite, name)
      @suite = suite
      @name  = name
    end

    def root
      suite.root
    end

    def full_path
      File.join(root, Evergreen.helper_dir, name)
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

    def exist?
      File.exist?(full_path)
    end
  end
end
