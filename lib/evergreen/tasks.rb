require 'evergreen'

# Rails 2.3 Rake tasks
namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts => :environment do
    result = Evergreen::Runner.new.run
    Kernel.exit(1) unless result
  end
end
