require 'evergreen'
require 'rails'

module Evergreen
  def self.rails
    Evergreen::Suite.new(Rails.root).application
  end

  class Railtie < Rails::Engine
  end
end

