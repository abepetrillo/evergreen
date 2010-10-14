require 'spec_helper'

describe Evergreen::Spec do
  let(:root) { File.expand_path('suite1', File.dirname(__FILE__)) }
  let(:suite) { Evergreen::Suite.new(root) }
  subject { Evergreen::Spec.new(suite, 'testing_spec.js') }

  its(:name) { should == 'testing_spec.js' }
  its(:root) { should == root }
  its(:full_path) { should == "#{root}/spec/javascripts/testing_spec.js" }
  its(:url) { should == "/run/testing_spec.js" }
  its(:contents) { should =~ /describe\('testing'/ }

  context "with coffeescript" do
    subject { Evergreen::Spec.new(suite, 'coffeescript_spec.coffee') }
    its(:contents) { should =~ /describe\('coffeescript', function/ }
  end

  context "with existing spec file" do
    it { should exist }
  end

  context "with missing spec file" do
    subject { Evergreen::Spec.new(suite, 'does_not_exist.js') }
    it { should_not exist }
  end

end
