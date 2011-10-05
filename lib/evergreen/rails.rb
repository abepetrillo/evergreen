require 'evergreen'
require 'rails'

module Evergreen
  if defined?(Rails::Engine)
    class Railtie < Rails::Engine
      initializer 'evergreen.config' do
        Evergreen.application = Rails.application
        Evergreen.root = Rails.root
        Evergreen.mounted_at = "/evergreen"
      end
    end
  end
end
