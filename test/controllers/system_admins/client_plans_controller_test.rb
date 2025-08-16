require "test_helper"

class SystemAdmins::ClientPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_client_plan = system_admins_client_plans(:one)
  end

  test "should get index" do
    get system_admins_client_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_client_plan_url
    assert_response :success
  end

  test "should create system_admins_client_plan" do
    assert_difference("SystemAdmins::ClientPlan.count") do
      post system_admins_client_plans_url, params: { system_admins_client_plan: { client_id: @system_admins_client_plan.client_id, plan_id: @system_admins_client_plan.plan_id } }
    end

    assert_redirected_to system_admins_client_plan_url(SystemAdmins::ClientPlan.last)
  end

  test "should show system_admins_client_plan" do
    get system_admins_client_plan_url(@system_admins_client_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_client_plan_url(@system_admins_client_plan)
    assert_response :success
  end

  test "should update system_admins_client_plan" do
    patch system_admins_client_plan_url(@system_admins_client_plan), params: { system_admins_client_plan: { client_id: @system_admins_client_plan.client_id, plan_id: @system_admins_client_plan.plan_id } }
    assert_redirected_to system_admins_client_plan_url(@system_admins_client_plan)
  end

  test "should destroy system_admins_client_plan" do
    assert_difference("SystemAdmins::ClientPlan.count", -1) do
      delete system_admins_client_plan_url(@system_admins_client_plan)
    end

    assert_redirected_to system_admins_client_plans_url
  end
end
