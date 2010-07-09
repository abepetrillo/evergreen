require 'spec_helper'

describe Evergreen, ".application" do
  include Capybara

  it "should show a successful test run" do
    visit("/")
    click_link("testing_spec.js")
    page.should have_content("2 specs, 0 failures")
  end

  it "should show a successful test run for a coffeescript spec" do
    visit("/")
    click_link("coffeescript_spec.coffee")
    page.should have_content("2 specs, 0 failures")
  end

  it "should show errors for a failing spec" do
    visit("/")
    click_link("failing_spec.js")
    page.should have_content("2 specs, 1 failure")
    page.should have_content("Expected 'bar' to equal 'noooooo'.")
  end
end
