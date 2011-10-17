require 'evergreen'
require 'rails'

module Evergreen
  if defined?(Rails::Engine)
    class Railtie < Rails::Engine
      initializer 'evergreen.config' do
        Evergreen.application = Rails.application
        Evergreen.root = Rails.root
        Evergreen.root = File.expand_path('../../', Evergreen.root) if Rails.application.engine_name == 'dummy_application'
        Evergreen.mounted_at = "/evergreen"
      end
    end
  end
end
