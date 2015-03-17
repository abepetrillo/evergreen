require 'spec_helper'

describe Evergreen::Application do
  include Capybara::DSL

  it "should show a successful test run" do
    visit("/")
    click_link("testing_spec.js")
    expect(page).to have_content "2 specs, 0 failures"
  end

  it "should show a successful test run for a coffeescript spec" do
    visit("/")
    click_link("coffeescript_spec.coffee")
    expect(page).to have_content("2 specs, 0 failures")
  end

  it "should show errors for a failing spec" do
    visit("/")
    click_link("failing_spec.js")
    expect(page).to have_content("2 specs, 1 failure")
    expect(page).to have_content("Expected 'bar' to equal 'noooooo'.")
  end

  it "should run all specs" do
    visit("/")
    click_link("All")
    expect(page).to have_content("18 specs, 3 failures")
    expect(page).to have_content("Expected 'bar' to equal 'noooooo'.")
  end

  it "should run a spec inline" do
    visit("/")
    within('li', :text => 'testing_spec.js') do
      click_link("Run")
      expect(page).to have_content('Pass')
    end
  end

  it "should run a failing spec inline" do
    visit("/")
    within('li', :text => 'failing_spec.js') do
      click_link("Run")
      begin
        expect(page).to have_content('Fail')
      rescue # why you make me sad, Capybara webkit???
        expect(page).to have_content('Fail')
      end
    end
  end
end
