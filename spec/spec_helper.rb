require 'evergreen'
require 'rspec'

require 'capybara/dsl'
require 'capybara/envjs'

Capybara.app = Evergreen.application(File.expand_path('fixtures', File.dirname(__FILE__)))
Capybara.default_driver = :envjs
