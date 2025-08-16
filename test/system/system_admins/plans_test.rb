require "application_system_test_case"

class SystemAdmins::PlansTest < ApplicationSystemTestCase
  setup do
    @system_admins_plan = system_admins_plans(:one)
  end

  test "visiting the index" do
    visit system_admins_plans_url
    assert_selector "h1", text: "Plans"
  end

  test "should create plan" do
    visit system_admins_plans_url
    click_on "New plan"

    fill_in "Description", with: @system_admins_plan.description
    fill_in "Price", with: @system_admins_plan.price
    check "Status" if @system_admins_plan.status
    click_on "Create Plan"

    assert_text "Plan was successfully created"
    click_on "Back"
  end

  test "should update Plan" do
    visit system_admins_plan_url(@system_admins_plan)
    click_on "Edit this plan", match: :first

    fill_in "Description", with: @system_admins_plan.description
    fill_in "Price", with: @system_admins_plan.price
    check "Status" if @system_admins_plan.status
    click_on "Update Plan"

    assert_text "Plan was successfully updated"
    click_on "Back"
  end

  test "should destroy Plan" do
    visit system_admins_plan_url(@system_admins_plan)
    click_on "Destroy this plan", match: :first

    assert_text "Plan was successfully destroyed"
  end
end
