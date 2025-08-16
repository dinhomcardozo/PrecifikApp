require "test_helper"

class SystemAdmins::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_user = system_admins_users(:one)
  end

  test "should get index" do
    get system_admins_users_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_user_url
    assert_response :success
  end

  test "should create system_admins_user" do
    assert_difference("SystemAdmins::User.count") do
      post system_admins_users_url, params: { system_admins_user: { admin: @system_admins_user.admin, client_id: @system_admins_user.client_id, company_id: @system_admins_user.company_id, email: @system_admins_user.email, first_name: @system_admins_user.first_name, last_name: @system_admins_user.last_name, phone: @system_admins_user.phone } }
    end

    assert_redirected_to system_admins_user_url(SystemAdmins::User.last)
  end

  test "should show system_admins_user" do
    get system_admins_user_url(@system_admins_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_user_url(@system_admins_user)
    assert_response :success
  end

  test "should update system_admins_user" do
    patch system_admins_user_url(@system_admins_user), params: { system_admins_user: { admin: @system_admins_user.admin, client_id: @system_admins_user.client_id, company_id: @system_admins_user.company_id, email: @system_admins_user.email, first_name: @system_admins_user.first_name, last_name: @system_admins_user.last_name, phone: @system_admins_user.phone } }
    assert_redirected_to system_admins_user_url(@system_admins_user)
  end

  test "should destroy system_admins_user" do
    assert_difference("SystemAdmins::User.count", -1) do
      delete system_admins_user_url(@system_admins_user)
    end

    assert_redirected_to system_admins_users_url
  end
end
