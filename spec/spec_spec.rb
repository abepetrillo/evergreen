require 'spec_helper'

describe Evergreen::Spec do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Spec.new(suite, 'testing_spec.js') }

  it 'has the correct details' do
    expect(subject.name).to eq 'testing_spec.js'
    expect(subject.root).to eq File.expand_path('suite1', File.dirname(__FILE__))
    expect(subject.full_path).to eq File.expand_path("spec/javascripts/testing_spec.js", Evergreen.root)
    expect(subject.url).to eq "/run/testing_spec.js"
    expect(subject.contents).to include "describe\('testing'"
  end

  context "with coffeescript" do
    subject { Evergreen::Spec.new(suite, 'coffeescript_spec.coffee') }
    it 'contains coffeescript' do
      expect(subject.contents).to include "describe\('coffeescript', function"
    end
  end

  context "with existing spec file" do
    it { should exist }
  end

  context "with missing spec file" do
    subject { Evergreen::Spec.new(suite, 'does_not_exist.js') }
    it { should_not exist }
  end

end
