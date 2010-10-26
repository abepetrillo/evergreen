module Evergreen
  class Server
    attr_reader :suite

    def initialize(suite)
      @suite = suite
    end

    def serve
      server.boot
      Launchy.open(server.url('/'))
      trap(:INT) do
        if server.respond_to?(:shutdown)
          server.shutdown
        else
          exit
        end
      end
      sleep
    end

  protected

    def server
      @server ||= Capybara::Server.new(suite.application)
    end
  end
end

