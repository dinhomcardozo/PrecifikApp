require "application_system_test_case"

class SystemAdmins::ClientPlansTest < ApplicationSystemTestCase
  setup do
    @system_admins_client_plan = system_admins_client_plans(:one)
  end

  test "visiting the index" do
    visit system_admins_client_plans_url
    assert_selector "h1", text: "Client plans"
  end

  test "should create client plan" do
    visit system_admins_client_plans_url
    click_on "New client plan"

    fill_in "Client", with: @system_admins_client_plan.client_id
    fill_in "Plan", with: @system_admins_client_plan.plan_id
    click_on "Create Client plan"

    assert_text "Client plan was successfully created"
    click_on "Back"
  end

  test "should update Client plan" do
    visit system_admins_client_plan_url(@system_admins_client_plan)
    click_on "Edit this client plan", match: :first

    fill_in "Client", with: @system_admins_client_plan.client_id
    fill_in "Plan", with: @system_admins_client_plan.plan_id
    click_on "Update Client plan"

    assert_text "Client plan was successfully updated"
    click_on "Back"
  end

  test "should destroy Client plan" do
    visit system_admins_client_plan_url(@system_admins_client_plan)
    click_on "Destroy this client plan", match: :first

    assert_text "Client plan was successfully destroyed"
  end
end
