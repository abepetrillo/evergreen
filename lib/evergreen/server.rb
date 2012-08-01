module Evergreen
  class Server
    attr_reader :suite

    def serve
      server.boot
      Launchy.open(server.url(Evergreen.mounted_at.to_s + '/'))
      trap('SIGINT') { puts 'Shutting down...' ; exit 0 }
      sleep
    end

  protected

    def server
      @server ||= Capybara::Server.new(Evergreen.application)
    end
  end
end

