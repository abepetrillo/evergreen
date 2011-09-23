require 'spec_helper'

describe Evergreen::Suite do
  subject { Evergreen::Suite.new }

  its(:root) { should == File.expand_path('suite1', File.dirname(__FILE__)) }

  describe '#get_spec' do
    subject { Evergreen::Suite.new.get_spec('testing_spec.js') }
    its(:name) { should == 'testing_spec.js' }
    its(:root) { should == File.expand_path('suite1', File.dirname(__FILE__)) }
  end

  describe '#specs' do
    it "should find all specs recursively in the given root directory" do
      subject.specs.map(&:name).should include('testing_spec.js', 'foo_spec.js', 'bar_spec.js', 'libs/lucid_spec.js', 'models/game_spec.js')
    end
  end

  describe '#templates' do
    it "should find all specs in the given root directory" do
      subject.templates.map(&:name).should include('one_template.html', 'another_template.html')
    end
  end
end
