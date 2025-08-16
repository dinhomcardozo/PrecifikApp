require "application_system_test_case"

class SystemAdmins::UsersTest < ApplicationSystemTestCase
  setup do
    @system_admins_user = system_admins_users(:one)
  end

  test "visiting the index" do
    visit system_admins_users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit system_admins_users_url
    click_on "New user"

    check "Admin" if @system_admins_user.admin
    fill_in "Client", with: @system_admins_user.client_id
    fill_in "Company", with: @system_admins_user.company_id
    fill_in "Email", with: @system_admins_user.email
    fill_in "First name", with: @system_admins_user.first_name
    fill_in "Last name", with: @system_admins_user.last_name
    fill_in "Phone", with: @system_admins_user.phone
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "should update User" do
    visit system_admins_user_url(@system_admins_user)
    click_on "Edit this user", match: :first

    check "Admin" if @system_admins_user.admin
    fill_in "Client", with: @system_admins_user.client_id
    fill_in "Company", with: @system_admins_user.company_id
    fill_in "Email", with: @system_admins_user.email
    fill_in "First name", with: @system_admins_user.first_name
    fill_in "Last name", with: @system_admins_user.last_name
    fill_in "Phone", with: @system_admins_user.phone
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "should destroy User" do
    visit system_admins_user_url(@system_admins_user)
    click_on "Destroy this user", match: :first

    assert_text "User was successfully destroyed"
  end
end
