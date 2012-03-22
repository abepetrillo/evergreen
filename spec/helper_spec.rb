require 'spec_helper'

describe Evergreen::Helper do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Helper.new(suite, 'spec_helper.js') }

  its(:name) { should == 'spec_helper.js' }
  its(:root) { should == File.expand_path('suite1', File.dirname(__FILE__)) }
  its(:full_path) { should == File.expand_path("spec/javascripts/helpers/spec_helper.js", Evergreen.root) }
  its(:contents)  { should =~ %r(var SpecHelper = { spec: 'helper' };) }

  context "with coffeescript" do
    subject { Evergreen::Helper.new(suite, 'spec_helper.coffee') }
    its(:contents) { should =~ /window.CoffeeSpecHelper/ }
  end

  context "with existing spec file" do
    it { should exist }
  end

  context "with missing spec file" do
    subject { Evergreen::Helper.new(suite, 'does_not_exist.js') }
    it { should_not exist }
  end
end
