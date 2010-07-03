module Evergreen
  class Server
    def self.run(root)
      serve = new(root)
      serve.boot
      serve.launch_browser
    end

    def initialize(root)
      @root = root
    end

    def server
      @server ||= Capybara::Server.new(Evergreen.application(@root))
    end

    def boot
      server.boot
    end

    def root_url
      server.url('/')
    end

    def launch_browser
      Launchy.open(root_url)
      sleep
    end
  end
end

