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

  end
end
