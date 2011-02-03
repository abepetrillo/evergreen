module Evergreen
  class Suite
    attr_reader :root, :runner, :server, :driver, :application

    def initialize(root)
      @root = root

      paths = [
        File.expand_path("config/evergreen.rb", root),
        File.expand_path(".evergreen", root),
        "#{ENV["HOME"]}/.evergreen"
      ]
      paths.each { |path| load(path) if File.exist?(path) }

      @runner = Runner.new(self)
      @server = Server.new(self)
      @application = Evergreen.application(self)
    end

    def run
      runner.run
    end

    def serve
      server.serve
    end

    def get_spec(name)
      Spec.new(self, name)
    end

    def specs
      Dir.glob(File.join(root, Evergreen.spec_dir, '**', '*_spec.{js,coffee}')).map do |path|
        Spec.new(self, File.basename(path))
      end
    end

    def templates
      Dir.glob(File.join(root, Evergreen.template_dir, '*')).map do |path|
        Template.new(self, File.basename(path))
      end
    end
  end
end
