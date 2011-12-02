require 'spec_helper'

describe Evergreen::Suite do
  let(:files) { [] }
  subject { Evergreen::Suite.new(files) }

  its(:root) { should == File.expand_path('suite1', File.dirname(__FILE__)) }

  describe '#get_spec' do
    subject { Evergreen::Suite.new.get_spec('testing_spec.js') }
    its(:name) { should == 'testing_spec.js' }
    its(:root) { should == File.expand_path('suite1', File.dirname(__FILE__)) }
  end

  describe '#specs' do
    it "should find all specs recursively in the given root directory" do
      subject.specs.map(&:name).should include(*%w(testing_spec.js foo_spec.js bar_spec.js libs/lucid_spec.js models/game_spec.js))
    end
  end

  describe '#templates' do
    it "should find all specs in the given root directory" do
      subject.templates.map(&:name).should include(*%w(one_template.html another_template.html))
    end
  end

  context "files passed" do
    let(:files) { %w(spec/javascripts/testing_spec.js spec/javascripts/libs/lucid_spec.js) }
    it { should have(2).specs }

    describe '#specs' do
      it "should find specs passed to suite" do
        subject.specs.map(&:name).should include(*%w(testing_spec.js libs/lucid_spec.js))
      end
    end
  end

end
