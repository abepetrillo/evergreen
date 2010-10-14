require 'rubygems'
require 'bundler/setup'

require 'evergreen'
require 'rspec'

require 'capybara/dsl'

Capybara.app = Evergreen::Suite.new(File.expand_path('suite1', File.dirname(__FILE__))).application
Capybara.default_driver = :selenium

module EvergreenMatchers
  class PassSpec # :nodoc:
    def matches?(actual)
      @actual = actual
      @actual.passed?
    end

    def failure_message
      "expected #{@actual.name} to pass, but it failed with:\n\n#{@actual.failure_messages}"
    end

    def negative_failure_message
      "expected #{@actual.name} not to pass, but it did"
    end
  end

  def pass
    PassSpec.new
  end
end

RSpec.configure do |config|
  config.include EvergreenMatchers
end
