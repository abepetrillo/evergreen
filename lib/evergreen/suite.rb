module Evergreen
  class Suite
    attr_reader :root, :runner, :server, :driver, :application

    def initialize(root, driver=:serve)
      @root = root
      @driver = driver
      @runner = Runner.new(self)
      @server = Server.new(self)
      @application = Evergreen.application(self, driver)
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
      Dir.glob(File.join(root, 'spec/javascripts', '*_spec.{js,coffee}')).map do |path|
        Spec.new(self, File.basename(path))
      end
    end

    def templates
      Dir.glob(File.join(root, 'spec/javascripts/templates', '*')).map do |path|
        Template.new(self, File.basename(path))
      end
    end
  end
end
