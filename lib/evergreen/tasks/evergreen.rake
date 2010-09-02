namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts do
    result = Evergreen::Runner.run(Rails.root)
    Kernel.exit(1) unless result
  end
end
