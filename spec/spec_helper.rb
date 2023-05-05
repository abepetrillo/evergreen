require 'rubygems'
require 'bundler/setup'

require 'evergreen'
require 'rspec'

require 'capybara/dsl'
require "capybara/cuprite"

require 'pry'

require 'coveralls'
Coveralls.wear!

TEST_DRIVER = :cuprite

Evergreen.root = File.expand_path('suite1', File.dirname(__FILE__))

Capybara.app = Evergreen::Application
Capybara.default_driver = TEST_DRIVER

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800])
end

module EvergreenMatchers
  class PassSpec # :nodoc:

    def description
      'Successfull if the runner manages to pass all the JS specs'
    end

    def matches?(actual)
      @actual = actual
      @runner = Evergreen::Runner.new(StringIO.new).spec_runner(@actual)
      @runner.passed?
    end

    def failure_message
      "expected #{@actual.name} to pass, but it failed with:\n\n#{@runner.failure_messages}"
    end

    def failure_message_when_negated
      "expected #{@actual.name} not to pass, but it did"
    end
  end

  def pass
    PassSpec.new
  end
end

RSpec.configure do |config|
  config.include EvergreenMatchers
  config.before do
    Capybara.reset_sessions!
    Evergreen.use_defaults!
    Evergreen.root = File.expand_path('suite1', File.dirname(__FILE__))
    Evergreen.driver = TEST_DRIVER
  end
end
