namespace :spec do
  desc "Run JavaScript specs via Evergreen"
  task :javascripts => [:precompile_assets] do
      result = Evergreen::Suite.new(Rails.root).run
      Kernel.exit(1) unless result 
      Rake.application['spec:clean_assets'].invoke
  end

  desc "Precompile Assets for Testing"
  task :precompile_assets do
    if !!Rails.version.match(/^3\.1.*/) && Rails.application.config.assets
      puts "=== Rails 3.1 Application & Asset Pipeline Detected - Precompiling Assets for Testing ===" 
      Rake.application['environment'].invoke
      test_asset_path = Rails.root.join("public/assets")
      sh "mkdir -p #{test_asset_path}", {:verbose => false}
      Rails.application.assets.static_root = test_asset_path
      Rake.application['spec:clean_assets'].invoke
      Rake.application['assets:precompile'].invoke
      normalize_asset_names
    end 
  end

  desc "Clean Up Previously Compiled Assets"
  task :clean_assets do
    puts "=== Cleaning Up Assets ==="
    sh "rm -rf #{Rails.root.join("public/assets")}", {:verbose => false} || raise("Unable to Clean Precompiled Assets")
  end
end

def normalize_asset_names
  puts "=== Normalizing Asset Names ==="
  sh "touch #{Rails.root.join('public/assets/asset_list')}", {:verbose => false}
  sh "echo `ls #{Rails.root.join('public/assets/')}` >> #{Rails.root.join('public/assets/asset_list')}", {:verbose => false}
  File.open(Rails.root.join('public/assets/asset_list'), "r") do |asset_list|
    file_to_move = []
    asset_list.each_line do |line| 
      line.chomp!
      line.to_s.split(" ").map{|x| file_to_move << x if x.match(/\.(js|css|png)$/) }
    end
    file_to_move.each do |filename|
      new_filename = filename.gsub(/-\w*/, "")
      sh "mv #{Rails.root.join('public/assets/' + filename)} #{Rails.root.join('public/assets/' + new_filename)}", {:verbose => false}
    end
  end
end
