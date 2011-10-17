module Evergreen
  class << self
    attr_writer :application

    def application
      @application ||= build_application
    end

    def build_application
      Evergreen.load_user_config!

      Rack::Builder.new do
        instance_eval(&Evergreen.extensions) if Evergreen.extensions

        map "/jasmine" do
          use Rack::Static, :urls => ["/"], :root => File.expand_path('../jasmine/lib', File.dirname(__FILE__))
          run lambda { |env| [404, {}, "No such file"]}
        end

        map "/resources" do
          use Rack::Static, :urls => ["/"], :root => File.expand_path('resources', File.dirname(__FILE__))
          run lambda { |env| [404, {}, "No such file"]}
        end

        map "/" do
          app = Class.new(Sinatra::Base).tap do |app|
            app.reset!
            app.class_eval do
              set :static, true
              set :root, File.expand_path('.', File.dirname(__FILE__))
              set :public_folder, File.expand_path(File.join(Evergreen.root, Evergreen.public_dir), File.dirname(__FILE__))

              helpers do
                def url(path)
                  Evergreen.mounted_at.to_s + path.to_s
                end

                def render_spec(spec)
                  spec.read if spec
                rescue StandardError => error
                  erb :_spec_error, :locals => { :error => error }
                end
              end

              get '/' do
                @suite = Evergreen::Suite.new
                erb :list
              end

              get '/run/all' do
                @suite = Evergreen::Suite.new
                @js_spec_helper = @suite.get_spec('spec_helper.js')
                @coffee_spec_helper = @suite.get_spec('spec_helper.coffee')
                erb :run
              end

              get '/run/*' do |name|
                @suite = Evergreen::Suite.new
                @spec = @suite.get_spec(name)
                @js_spec_helper = @suite.get_spec('spec_helper.js')
                @coffee_spec_helper = @suite.get_spec('spec_helper.coffee')
                erb :run
              end
            end
          end
          run app
        end
      end.tap do |app|
        def app.inspect; '<Evergreen Application>'; end
      end
    end
  end
end
