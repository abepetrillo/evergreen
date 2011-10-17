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
    attr_accessor :driver, :public_dir, :template_dir, :spec_dir, :root, :mounted_at

    def configure
      yield self
    end

    def extensions(&block)
      @extensions = block if block
      @extensions
    end

    def use_defaults!
      configure do |config|
        config.driver = :selenium
        config.public_dir = 'public'
        config.spec_dir = 'spec/javascripts'
        config.template_dir = 'spec/javascripts/templates'
        config.mounted_at = ""
      end
    end

    def load_user_config!
      paths = [
        File.expand_path("config/evergreen.rb", root),
        File.expand_path(".evergreen", root),
        "#{ENV["HOME"]}/.evergreen"
      ]
      paths.each { |path| load(path) if File.exist?(path) }
    end
  end
end

Evergreen.use_defaults!
