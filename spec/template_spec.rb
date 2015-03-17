require 'spec_helper'

describe Evergreen::Template do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Template.new(suite, 'one_template.html') }

  it 'has the correct details' do
    expect(subject.name).to eq 'one_template.html'
    expect(subject.root).to eq File.expand_path('suite1', File.dirname(__FILE__))
    expect(subject.full_path).to eq File.expand_path("spec/javascripts/templates/one_template.html", Evergreen.root)
    expect(subject.contents).to include '<h1 id="from-template">This is from the template</h1>'
  end

  describe '.exist?' do
    context "with existing spec file" do
      it 'returns true' do
        expect(subject.exist?).to eq true
      end
    end

    context "with missing spec file" do
      subject { Evergreen::Template.new(suite, 'does_not_exist.html') }
      it 'returns false' do
        expect(subject.exist?).to eq false
      end
    end
  end

end

describe Evergreen::Template, "escaping" do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Template.new(suite, 'escape.html') }

  it "escapes contents" do
    expect(subject.escaped_contents.strip).to eq %{"<scr" + "ipt>var foo = 0;</scr" + "ipt>\\n"}
  end
end
