require 'spec_helper'

describe Evergreen::FilesHelper do
  describe '.root' do
    subject { Evergreen::FilesHelper.root }
    it { should == File.expand_path('suite1', File.dirname(__FILE__)) }
  end

  describe '.find_all_spec_files' do
    subject { Evergreen::FilesHelper.find_all_spec_files }

    it "should return full paths of spec files" do
      files = %w(testing_spec.js foo_spec.js bar_spec.js libs/lucid_spec.js models/game_spec.js)
      paths = files.map { |file| File.expand_path('suite1/spec/javascripts/' + file, File.dirname(__FILE__)) }
      subject.should include(*paths)
    end
  end

  describe '.find_spec_files' do
    subject { Evergreen::FilesHelper.find_spec_files(files) }

    context "directory" do
      let(:files) { %w(spec/javascripts/libs) }
      it { should have(1).path }
    end

    context "files" do
      let(:files) { %w(spec/javascripts/foo_spec.js spec/javascripts/models/game_spec.js) }
      it { should have(2).paths }
    end

    context "incorrect file passed" do
      let(:files) { %w(non_existent.js) }
      it { should have(:no).paths }
    end

  end
end
