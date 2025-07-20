require "application_system_test_case"

class FixedCostsTest < ApplicationSystemTestCase
  setup do
    @fixed_cost = fixed_costs(:one)
  end

  test "visiting the index" do
    visit fixed_costs_url
    assert_selector "h1", text: "Fixed costs"
  end

  test "should create fixed cost" do
    visit fixed_costs_url
    click_on "New fixed cost"

    fill_in "Description", with: @fixed_cost. description
    fill_in "Fixed cost type", with: @fixed_cost. fixed_cost_type
    fill_in "Monthly cost", with: @fixed_cost. monthly_cost
    click_on "Create Fixed cost"

    assert_text "Fixed cost was successfully created"
    click_on "Back"
  end

  test "should update Fixed cost" do
    visit fixed_cost_url(@fixed_cost)
    click_on "Edit this fixed cost", match: :first

    fill_in "Description", with: @fixed_cost. description
    fill_in "Fixed cost type", with: @fixed_cost. fixed_cost_type
    fill_in "Monthly cost", with: @fixed_cost. monthly_cost
    click_on "Update Fixed cost"

    assert_text "Fixed cost was successfully updated"
    click_on "Back"
  end

  test "should destroy Fixed cost" do
    visit fixed_cost_url(@fixed_cost)
    click_on "Destroy this fixed cost", match: :first

    assert_text "Fixed cost was successfully destroyed"
  end
end
