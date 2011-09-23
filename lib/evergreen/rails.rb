require 'evergreen'
require 'rails'

module Evergreen
  class Railtie < Rails::Engine
    initializer 'evergreen.config' do
      Evergreen.application = Rails.application
      Evergreen.root = Rails.root
      Evergreen.mounted_at = "/evergreen"
    end
  end
end
