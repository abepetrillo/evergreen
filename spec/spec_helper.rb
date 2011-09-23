require 'rubygems'
require 'bundler/setup'

require 'evergreen'
require 'rspec'

require 'capybara/dsl'
require 'capybara-webkit'

TEST_DRIVER = :webkit

Evergreen.root = File.expand_path('suite1', File.dirname(__FILE__))
Evergreen.extensions do
  map "/awesome" do
    run lambda { |env| [200, {'Content-Type' => 'text/html'}, ["<html><body>Totally awesome</body></html>"]]}
  end
end

Capybara.app = Evergreen.application
Capybara.default_driver = TEST_DRIVER

module EvergreenMatchers
  class PassSpec # :nodoc:
    def matches?(actual)
      @actual = actual
      @runner = Evergreen::Runner.new(actual.suite, StringIO.new).spec_runner(@actual)
      @runner.passed?
    end

    def failure_message
      "expected #{@actual.name} to pass, but it failed with:\n\n#{@runner.failure_messages}"
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
  config.before do
    Evergreen.use_defaults!
    Evergreen.root = File.expand_path('suite1', File.dirname(__FILE__))
    Evergreen.driver = TEST_DRIVER
    Evergreen.application = Evergreen.build_application
  end
end
