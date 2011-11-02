# Rails 3.0/3.1 Rake tasks
namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts => :environment do
    result = Evergreen::Runner.new.run
    Kernel.exit(1) unless result
  end
end
