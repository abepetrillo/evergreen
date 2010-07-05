require 'spec_helper'

describe Evergreen::Spec do
  let(:root) { File.expand_path('fixtures', File.dirname(__FILE__)) }

  describe '#path' do
    it "should return the full path" do
      Evergreen::Spec.new(root, 'testing').path.should == "#{root}/spec/javascripts/testing_spec.js"
    end
  end
end
