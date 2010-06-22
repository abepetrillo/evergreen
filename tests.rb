require 'rubygems'
require 'sinatra'

PATH = File.expand_path('specs', File.dirname(__FILE__))

get '/' do
  @files = Dir.glob(File.join(PATH, '*_spec.js')).map { |f| File.basename(f).sub(/_spec\.js$/, '') }
  erb :list
end

get '/spec/:name' do |name|
  @file = File.join(PATH, name + '_spec.js')
  erb :spec
end
