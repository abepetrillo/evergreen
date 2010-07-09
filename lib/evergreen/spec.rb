module Evergreen
  class Spec

    def self.all(root)
      Dir.glob(File.join(root, 'spec/javascripts', '*_spec.{js,coffee}')).map do |path|
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

    def template_path
      full_path.sub(/\..+$/, '.html')
    end

    def template
      if File.exist?(template_path) then File.read(template_path) else "" end
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

    def exist?
      File.exist?(full_path)
    end

  end
end
