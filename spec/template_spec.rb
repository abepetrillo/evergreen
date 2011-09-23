require 'spec_helper'

describe Evergreen::Template do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Template.new(suite, 'one_template.html') }

  its(:name) { should == 'one_template.html' }
  its(:root) { should == File.expand_path('suite1', File.dirname(__FILE__)) }
  its(:full_path) { should == File.expand_path("spec/javascripts/templates/one_template.html", Evergreen.root) }
  its(:contents) { should =~ %r(<h1 id="from\-template">This is from the template</h1>) }

  context "with existing spec file" do
    it { should exist }
  end

  context "with missing spec file" do
    subject { Evergreen::Template.new(suite, 'does_not_exist.html') }
    it { should_not exist }
  end

end

describe Evergreen::Template, "escaping" do
  let(:suite) { Evergreen::Suite.new }
  subject { Evergreen::Template.new(suite, 'escape.html') }

  it "escapes contents" do
    subject.escaped_contents.strip.should == %{"<scr" + "ipt>var foo = 0;</scr" + "ipt>\\n"}
  end
end
