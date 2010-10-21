require 'rubygems'
require 'sinatra/base'
require 'capybara'
require 'capybara/wait_until'
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
    attr_accessor :driver

    def configure
      yield self
    end
  end
end

Evergreen.configure do |config|
  config.driver = :selenium
end
