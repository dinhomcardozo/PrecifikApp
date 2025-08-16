require "test_helper"

class SystemAdmins::PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_plan = system_admins_plans(:one)
  end

  test "should get index" do
    get system_admins_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_plan_url
    assert_response :success
  end

  test "should create system_admins_plan" do
    assert_difference("SystemAdmins::Plan.count") do
      post system_admins_plans_url, params: { system_admins_plan: { description: @system_admins_plan.description, price: @system_admins_plan.price, status: @system_admins_plan.status } }
    end

    assert_redirected_to system_admins_plan_url(SystemAdmins::Plan.last)
  end

  test "should show system_admins_plan" do
    get system_admins_plan_url(@system_admins_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_plan_url(@system_admins_plan)
    assert_response :success
  end

  test "should update system_admins_plan" do
    patch system_admins_plan_url(@system_admins_plan), params: { system_admins_plan: { description: @system_admins_plan.description, price: @system_admins_plan.price, status: @system_admins_plan.status } }
    assert_redirected_to system_admins_plan_url(@system_admins_plan)
  end

  test "should destroy system_admins_plan" do
    assert_difference("SystemAdmins::Plan.count", -1) do
      delete system_admins_plan_url(@system_admins_plan)
    end

    assert_redirected_to system_admins_plans_url
  end
end
