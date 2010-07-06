require 'spec_helper'

describe Evergreen, ".application" do
  include Capybara

  it "should show a successful test run" do
    visit("/")
    click_link("testing")
    page.should have_content("2 specs, 0 failures")
  end

  it "should show errors for a failing spec" do
    visit("/")
    click_link("failing")
    page.should have_content("2 specs, 1 failure")
    page.should have_content("Expected 'bar' to equal 'noooooo'.")
  end
end
