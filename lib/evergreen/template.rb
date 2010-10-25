module Evergreen
  class Template
    attr_reader :name, :suite

    def initialize(suite, name)
      @suite = suite
      @name = name
    end

    def root
      suite.root
    end

    def full_path
      File.join(root, Evergreen.template_dir, name)
    end

    def read
      File.read(full_path)
    end
    alias_method :contents, :read

    def exist?
      File.exist?(full_path)
    end

  end
end
