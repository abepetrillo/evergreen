module Evergreen
  class Cli
    def self.execute(argv)
      new.execute(argv)
    end

    def execute(argv)
      command = argv.shift
      root    = File.expand_path(argv.shift || '.', Dir.pwd)

      case command
      when "serve"
        Evergreen::Server.run(root)
        return true
      when "run"
        return Evergreen::Runner.run(root)
      else
        puts "no such command '#{command}'"
        return false
      end
    end
  end
end
