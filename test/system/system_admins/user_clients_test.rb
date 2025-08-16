require "application_system_test_case"

class SystemAdmins::UserClientsTest < ApplicationSystemTestCase
  setup do
    @system_admins_user_client = system_admins_user_clients(:one)
  end

  test "visiting the index" do
    visit system_admins_user_clients_url
    assert_selector "h1", text: "User clients"
  end

  test "should create user client" do
    visit system_admins_user_clients_url
    click_on "New user client"

    fill_in "Client", with: @system_admins_user_client.client_id
    fill_in "User", with: @system_admins_user_client.user_id
    click_on "Create User client"

    assert_text "User client was successfully created"
    click_on "Back"
  end

  test "should update User client" do
    visit system_admins_user_client_url(@system_admins_user_client)
    click_on "Edit this user client", match: :first

    fill_in "Client", with: @system_admins_user_client.client_id
    fill_in "User", with: @system_admins_user_client.user_id
    click_on "Update User client"

    assert_text "User client was successfully updated"
    click_on "Back"
  end

  test "should destroy User client" do
    visit system_admins_user_client_url(@system_admins_user_client)
    click_on "Destroy this user client", match: :first

    assert_text "User client was successfully destroyed"
  end
end
