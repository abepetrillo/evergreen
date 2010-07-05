require 'spec_helper'

describe Evergreen::Spec do
  let(:root) { File.expand_path('fixtures', File.dirname(__FILE__)) }
  subject { Evergreen::Spec.new(root, 'testing') }

  its(:name) { should == 'testing' }
  its(:root) { should == root }
  its(:path) { should == "#{root}/spec/javascripts/testing_spec.js" }
  its(:url) { should == "/run/testing" }
  its(:contents) { should =~ /describe\('testing'/ }

  describe '.all' do
    subject { Evergreen::Spec.all(root) }

    it "should find all specs in the given root directory" do
      subject.map(&:name).should include('testing', 'foo', 'bar')
    end
  end
end
