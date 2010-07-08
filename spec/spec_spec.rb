require 'spec_helper'

describe Evergreen::Spec do
  let(:root) { File.expand_path('fixtures', File.dirname(__FILE__)) }
  subject { Evergreen::Spec.new(root, 'testing_spec.js') }

  its(:name) { should == 'testing_spec.js' }
  its(:root) { should == root }
  its(:full_path) { should == "#{root}/spec/javascripts/testing_spec.js" }
  its(:url) { should == "/run/testing_spec.js" }
  its(:contents) { should =~ /describe\('testing'/ }

  describe '.all' do
    subject { Evergreen::Spec.all(root) }

    it "should find all specs in the given root directory" do
      subject.map(&:name).should include('testing_spec.js', 'foo_spec.js', 'bar_spec.js')
    end
  end
end
