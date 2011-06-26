# Rails 3.0/3.1 Rake tasks
namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts => :environment do
    result = Evergreen::Suite.new(Rails.root, :application => Rails.application, :mounted_at => '/evergreen').run
    Kernel.exit(1) unless result
  end
end
