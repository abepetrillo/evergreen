require 'rubygems'
require 'sinatra/base'
require 'capybara'
require 'launchy'
require 'evergreen/version'
require 'evergreen/application'
require 'json'

module Evergreen
  autoload :Cli, 'evergreen/cli'
  autoload :Server, 'evergreen/server'
  autoload :Runner, 'evergreen/runner'
  autoload :Suite, 'evergreen/suite'
  autoload :Spec, 'evergreen/spec'
  autoload :Template, 'evergreen/template'

  class << self
    attr_accessor :driver, :public_dir, :template_dir, :spec_dir, :root, :mounted_at, :application

    def configure
      yield self
    end

    def use_defaults!
      configure do |config|
        config.application = Evergreen::Application
        config.driver = :selenium
        config.public_dir = 'public'
        config.spec_dir = 'spec/javascripts'
        config.template_dir = 'spec/javascripts/templates'
        config.mounted_at = ""
      end
    end
  end
end

Evergreen.use_defaults!
