namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts do
    result = Evergreen::Suite.new(Rails.root, :selenium).run
    Kernel.exit(1) unless result
  end
end
