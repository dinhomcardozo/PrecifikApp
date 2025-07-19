require "application_system_test_case"

class SalesTargetsTest < ApplicationSystemTestCase
  setup do
    @sales_target = sales_targets(:one)
  end

  test "visiting the index" do
    visit sales_targets_url
    assert_selector "h1", text: "Sales targets"
  end

  test "should create sales target" do
    visit sales_targets_url
    click_on "New sales target"

    fill_in "Channel", with: @sales_target.channel_id
    fill_in "End date", with: @sales_target.end_date
    fill_in "Monthly target", with: @sales_target.monthly_target
    fill_in "Package", with: @sales_target.package_id
    fill_in "Start date", with: @sales_target.start_date
    click_on "Create Sales target"

    assert_text "Sales target was successfully created"
    click_on "Back"
  end

  test "should update Sales target" do
    visit sales_target_url(@sales_target)
    click_on "Edit this sales target", match: :first

    fill_in "Channel", with: @sales_target.channel_id
    fill_in "End date", with: @sales_target.end_date
    fill_in "Monthly target", with: @sales_target.monthly_target
    fill_in "Package", with: @sales_target.package_id
    fill_in "Start date", with: @sales_target.start_date
    click_on "Update Sales target"

    assert_text "Sales target was successfully updated"
    click_on "Back"
  end

  test "should destroy Sales target" do
    visit sales_target_url(@sales_target)
    click_on "Destroy this sales target", match: :first

    assert_text "Sales target was successfully destroyed"
  end
end
