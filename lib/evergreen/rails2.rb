require "evergreen"

module Evergreen
  class UrlPrepender
    def initialize app
      @app = app
    end

    def call headers
      status, headers, body = @app.call headers
      new_body = ""
      body.each do |part|
        new_body << part
      end

      new_body.gsub! /(src|href)="\//, '\1="/evergreen/'
      [status, headers, [new_body]]
    end
  end

  class Rails2
    def initialize app
      @app = app
    end
    
    def call headers
      builder = ::Rack::Builder.new do
        map "/evergreen" do
          use UrlPrepender
          run Evergreen::Application
        end
      end

      if headers["PATH_INFO"].starts_with? "/evergreen"
        builder.call headers
      else
        @app.call headers
      end
    end
  end
end
