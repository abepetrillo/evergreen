namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts do
    result = Evergreen::Suite.new(Rails.root).run
    Kernel.exit(1) unless result
  end
end

namespace :evergreen do
  desc 'publish evergreen results as reports/...xml (use ENV["CI_REPORTS"] to override)'
  task :ci do
    suite = Evergreen::Suite.new(Rails.root)
    Evergreen::Reports.publish!(suite)
    Kernel.exit(0)
  end
end