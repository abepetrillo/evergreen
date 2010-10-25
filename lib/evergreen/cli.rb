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
        Evergreen::Suite.new(root).serve
        return true
      when "run"
        return Evergreen::Suite.new(root).run
      else
        puts "no such command '#{command}'"
        return false
      end
    end
  end
end
