require "test_helper"

class SystemAdmins::UserClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_user_client = system_admins_user_clients(:one)
  end

  test "should get index" do
    get system_admins_user_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_user_client_url
    assert_response :success
  end

  test "should create system_admins_user_client" do
    assert_difference("SystemAdmins::UserClient.count") do
      post system_admins_user_clients_url, params: { system_admins_user_client: { client_id: @system_admins_user_client.client_id, user_id: @system_admins_user_client.user_id } }
    end

    assert_redirected_to system_admins_user_client_url(SystemAdmins::UserClient.last)
  end

  test "should show system_admins_user_client" do
    get system_admins_user_client_url(@system_admins_user_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_user_client_url(@system_admins_user_client)
    assert_response :success
  end

  test "should update system_admins_user_client" do
    patch system_admins_user_client_url(@system_admins_user_client), params: { system_admins_user_client: { client_id: @system_admins_user_client.client_id, user_id: @system_admins_user_client.user_id } }
    assert_redirected_to system_admins_user_client_url(@system_admins_user_client)
  end

  test "should destroy system_admins_user_client" do
    assert_difference("SystemAdmins::UserClient.count", -1) do
      delete system_admins_user_client_url(@system_admins_user_client)
    end

    assert_redirected_to system_admins_user_clients_url
  end
end
