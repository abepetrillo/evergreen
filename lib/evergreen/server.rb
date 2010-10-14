module Evergreen
  class Server
    attr_reader :suite

    def initialize(suite)
      @suite = suite
    end

    def serve
      server.boot
      Launchy.open(server.url('/'))
      sleep
    end

  protected

    def server
      @server ||= Capybara::Server.new(suite.application)
    end
  end
end

