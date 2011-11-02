module Evergreen
  class Cli
    def self.execute(argv)
      new.execute(argv)
    end

    def execute(argv)
      command = argv.shift
      Evergreen.root = File.expand_path(argv.shift || '.', Dir.pwd)

      # detect Rails apps
      if File.exist?(File.join(Evergreen.root, 'config/environment.rb'))
        require File.join(Evergreen.root, 'config/environment.rb')
        require 'evergreen/rails' if defined?(Rails)
      end

      case command
      when "serve"
        Evergreen::Server.new.serve
        return true
      when "run"
        return Evergreen::Runner.new.run
      else
        puts "no such command '#{command}'"
        return false
      end
    end
  end
end
