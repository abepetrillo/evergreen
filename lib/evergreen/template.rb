module Evergreen
  class Template

    def self.all(root)
      Dir.glob(File.join(root, 'spec/javascripts/templates', '*')).map do |path|
        new(root, File.basename(path))
      end
    end

    attr_reader :name, :root

    def initialize(root, name)
      @root = root
      @name = name
    end

    def full_path
      File.join(root, 'spec/javascripts/templates', name)
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
