module Evergreen
  class Spec

    def self.all(root)
      Dir.glob(File.join(root, 'spec/javascripts', '*_spec.js')).map do |path|
        new(root, File.basename(path))
      end
    end

    attr_reader :name, :root

    def initialize(root, name)
      @root = root
      @name = name
    end

    def full_path
      File.join(root, 'spec/javascripts', name)
    end

    def read
      File.read(full_path)
    end
    alias_method :contents, :read

    def url
      "/run/#{name}"
    end

  end
end
