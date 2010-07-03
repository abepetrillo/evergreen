require 'rubygems'
require 'sinatra/base'
require 'capybara'
require 'capybara/envjs'
require 'capybara/wait_until'
require 'launchy'
require 'evergreen/version'

module Evergreen
  autoload :Cli, 'evergreen/cli'
  autoload :Server, 'evergreen/server'
  autoload :Runner, 'evergreen/runner'
  autoload :Spec, 'evergreen/spec'

  class << self
    def application(root)
      Class.new(Sinatra::Base).tap do |app|
        app.reset! 
        app.class_eval do
          set :static, true
          set :root, File.expand_path('evergreen', File.dirname(__FILE__))
          set :public, File.expand_path(File.join(root, 'public'), File.dirname(__FILE__))

          use Rack::Static, :urls => ["/lib"], :root => File.expand_path('jasmine', File.dirname(__FILE__))
          use Rack::Static, :urls => ["/evergreen"], :root => File.dirname(__FILE__)

          get '/' do
            @specs = Spec.all(root)
            erb :list
          end

          get '/run/:name' do |name|
            @spec = Spec.new(root, name)
            erb :spec
          end

          get '/spec/:name.js' do |name|
            Spec.new(root, name).read
          end
        end
      end
    end
  end
end
