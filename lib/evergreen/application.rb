module Evergreen
  def self.application(suite)
    Rack::Builder.new do
      instance_eval(&Evergreen.extensions) if Evergreen.extensions

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
            set :public, File.expand_path(File.join(suite.root, Evergreen.public_dir), File.dirname(__FILE__))

            helpers do
              def url(path)
                request.env['SCRIPT_NAME'].to_s + path.to_s
              end
            end

            get '/' do
              @suite = suite
              erb :list
            end

            get '/run/*' do |name|
              @suite = suite
              @spec = suite.get_spec(name)
              @js_spec_helper = suite.get_spec('spec_helper.js')
              @coffee_spec_helper = suite.get_spec('spec_helper.coffee')
              erb :spec
            end
          end
        end
        run app
      end
    end
  end
end
