require 'spec_helper'

describe Evergreen::Suite do
  let(:root) { File.expand_path('suite1', File.dirname(__FILE__)) }
  subject { Evergreen::Suite.new(root) }

  its(:root) { should == root }

  describe '#get_spec' do
    subject { Evergreen::Suite.new(root).get_spec('testing_spec.js') }
    its (:name) { should == 'testing_spec.js' }
    its (:root) { should == root }
  end

  describe '#specs' do
    it "should find all specs in the given root directory" do
      subject.specs.map(&:name).should include('testing_spec.js', 'foo_spec.js', 'bar_spec.js', 'coffeescript_spec.coffee')
    end
  end

  describe '#templates' do
    it "should find all specs in the given root directory" do
      subject.templates.map(&:name).should include('one_template.html', 'another_template.html')
    end
  end
end
