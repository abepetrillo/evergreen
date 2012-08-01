module Evergreen

  class Suite

    attr_reader :driver, :files

    def initialize(files = [])
      @files = files
      paths = [
        File.expand_path("config/evergreen.rb", root),
        File.expand_path(".evergreen", root),
        "#{ENV["HOME"]}/.evergreen"
      ]
      paths.each { |path| load(path) if File.exist?(path) }
    end

    def root
      Evergreen.root
    end

    def mounted_at
      Evergreen.mounted_at
    end

    def files_helper
      Evergreen::FilesHelper
    end

    def get_spec(name)
      Spec.new(self, name)
    end

    def specs
      files_helper.find_specs(@files).map do |path|
        Spec.new(self, path.gsub(File.join(root, Evergreen.spec_dir, ''), ''))
      end
    end

    def templates
      files_helper.find_templates.map do |path|
        Template.new(self, File.basename(path))
      end
    end

  end

end
