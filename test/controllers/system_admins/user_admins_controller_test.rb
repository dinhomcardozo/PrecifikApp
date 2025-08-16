require "test_helper"

class SystemAdmins::UserAdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_user_admin = system_admins_user_admins(:one)
  end

  test "should get index" do
    get system_admins_user_admins_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_user_admin_url
    assert_response :success
  end

  test "should create system_admins_user_admin" do
    assert_difference("SystemAdmins::UserAdmin.count") do
      post system_admins_user_admins_url, params: { system_admins_user_admin: { admin: @system_admins_user_admin.admin, email: @system_admins_user_admin.email, full_name: @system_admins_user_admin.full_name, phone: @system_admins_user_admin.phone } }
    end

    assert_redirected_to system_admins_user_admin_url(SystemAdmins::UserAdmin.last)
  end

  test "should show system_admins_user_admin" do
    get system_admins_user_admin_url(@system_admins_user_admin)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_user_admin_url(@system_admins_user_admin)
    assert_response :success
  end

  test "should update system_admins_user_admin" do
    patch system_admins_user_admin_url(@system_admins_user_admin), params: { system_admins_user_admin: { admin: @system_admins_user_admin.admin, email: @system_admins_user_admin.email, full_name: @system_admins_user_admin.full_name, phone: @system_admins_user_admin.phone } }
    assert_redirected_to system_admins_user_admin_url(@system_admins_user_admin)
  end

  test "should destroy system_admins_user_admin" do
    assert_difference("SystemAdmins::UserAdmin.count", -1) do
      delete system_admins_user_admin_url(@system_admins_user_admin)
    end

    assert_redirected_to system_admins_user_admins_url
  end
end
