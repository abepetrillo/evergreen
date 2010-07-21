require 'spec_helper'

describe Evergreen::Template do
  let(:root) { File.expand_path('suite1', File.dirname(__FILE__)) }
  subject { Evergreen::Template.new(root, 'one_template.html') }

  its(:name) { should == 'one_template.html' }
  its(:root) { should == root }
  its(:full_path) { should == "#{root}/spec/javascripts/templates/one_template.html" }
  its(:contents) { should =~ %r(<h1 id="from\-template">This is from the template</h1>) }
  describe '.all' do
    subject { Evergreen::Template.all(root) }

    it "should find all specs in the given root directory" do
      subject.map(&:name).should include('one_template.html', 'another_template.html')
    end
  end

  context "with existing spec file" do
    it { should exist }
  end

  context "with missing spec file" do
    subject { Evergreen::Template.new(root, 'does_not_exist.html') }
    it { should_not exist }
  end

end
