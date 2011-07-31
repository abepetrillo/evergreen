namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts => [:precompile_assets] do
    begin
      result = Evergreen::Suite.new(Rails.root).run
      Kernel.exit(1) unless result 
    ensure
      Rake.application['spec:clean_assets'].invoke
    end
  end

  desc "Precompile Assets for Testing"
  task :precompile_assets do
    if !!Rails.version.match(/^3\.1.*/) 
      puts "Precompiling Assets for Testing" 
      Rake.application['environment'].invoke
      test_asset_path = Rails.root.join("public/test_assets")
      sh "mkdir -p #{test_asset_path}"
      Rails.application.assets.static_root = test_asset_path
      Rake.application['spec:clean_assets'].invoke
      Rake.application['assets:precompile'].invoke
      normalize_asset_names
      puts "Compilation Completed"
    end 
  end

  desc "Clean Up Previously Compiled Assets"
  task :clean_assets do
    puts "Cleaning Up Precompiled Assets"
    sh("rm -rf #{Rails.root.join("public/test_assets")}") || raise("Unable to Clean Precompiled Assets")
    puts "Cleaning Completed" 
  end
end

def normalize_asset_names
  puts "Normalizing Asset Names"
  sh "touch #{Rails.root.join('public/test_assets/asset_list')}"
  sh "echo `ls #{Rails.root.join('public/test_assets/')}` >> #{Rails.root.join('public/test_assets/asset_list')}"
  File.open(Rails.root.join('public/test_assets/asset_list'), "r") do |asset_list|
    file_to_move = []
    asset_list.each_line do |line| 
      line.chomp!
      line.to_s.split(" ").map{|x| x.match(/\.(js|css|png)$/) ? file_to_move << x : break}
    end
    file_to_move.each do |filename|
      new_filename = filename.gsub(/-\w*/, "")
      sh "mv #{Rails.root.join('public/test_assets/' + filename)} #{Rails.root.join('public/test_assets/' + new_filename)}"
    end
  end
  puts "Normalization Complete"
end
