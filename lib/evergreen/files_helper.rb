module Evergreen
  module FilesHelper
    PATTERN = '**/*_spec.{js,coffee}'

    class << self

      def root
        Evergreen.root
      end

      def find_specs(files)
        files.empty? ? find_all_spec_files : find_spec_files(files)
      end

      def find_spec_files(files)
        files.map do |file|
          if File.directory?(file)
            Dir.glob(File.join(root, "#{file}/{#{PATTERN}}"))
          else
            path = File.absolute_path(file, root)
            File.exist?(path) ? path : nil
          end
        end.flatten.compact
      end

      def find_all_spec_files
        Dir.glob(File.join(root, Evergreen.spec_dir, PATTERN))
      end

      def find_templates
        Dir.glob(File.join(root, Evergreen.template_dir, '*'))
      end
    end
  end
end
