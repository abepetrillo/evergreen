require 'spec_helper'
require 'rails/all'
require 'evergreen/rails'

class TestApplication < Rails::Engine
  def self.new; super end
end

describe Evergreen::Railtie do
  describe :evergreen_config_initializer do
    subject { Evergreen::Railtie.initializers.first.block }

    let(:test_app) { TestApplication.new }
    let(:test_engine) { TestEngine.new }

    before :each do
      Rails.stub(:application).and_return(test_app)
      Rails.stub(:root).and_return('/foo/bar/foobar')
      test_app.stub(:engine_name).and_return('some_app')
    end

    it "should set the mounted_at to /evergreen" do
      subject.call

      Evergreen.mounted_at.should == '/evergreen'
    end

    it "should set the application to the rails application" do
      subject.call

      Evergreen.application.should == test_app
    end

    it "should set the root to the rails root" do
      subject.call

      Evergreen.root.should == '/foo/bar/foobar'
    end

    context "when running in an engine" do
      before(:each) do
        test_app.stub(:engine_name).and_return('dummy_application')
      end

      it "should set the root to the Rails root then up 2 directories" do
        subject.call

        Evergreen.root.should == '/foo'
      end
    end
  end
end
