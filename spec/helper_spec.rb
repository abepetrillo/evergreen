require 'spec_helper'

describe Evergreen::Helper do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Helper.new(suite, 'spec_helper.js') }


  it 'has the corrent details' do
    expect(subject.name).to eq 'spec_helper.js'
    expect(subject.root).to eq File.expand_path('suite1', File.dirname(__FILE__))
    expect(subject.full_path).to eq File.expand_path("spec/javascripts/helpers/spec_helper.js", Evergreen.root)
    expect(subject.contents).to eq  "var SpecHelper = { spec: 'helper' };\n"
  end

  context "with coffeescript" do
    subject { Evergreen::Helper.new(suite, 'spec_helper.coffee') }
    it 'load the coffeeScript helper' do
      expect(subject.contents).to include 'window.CoffeeSpecHelper'
    end
  end

  describe '.exists' do
    context 'with existing spec file' do
      it 'returns true' do
        expect(subject.exist?).to eq true
      end
    end

    context "with missing spec file" do
      subject { Evergreen::Helper.new(suite, 'does_not_exist.js') }
      it 'returns false' do
        expect(subject.exist?).to eq false
      end
    end
  end
end
