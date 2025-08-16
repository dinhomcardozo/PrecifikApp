require "application_system_test_case"

class SystemAdmins::UserAdminsTest < ApplicationSystemTestCase
  setup do
    @system_admins_user_admin = system_admins_user_admins(:one)
  end

  test "visiting the index" do
    visit system_admins_user_admins_url
    assert_selector "h1", text: "User admins"
  end

  test "should create user admin" do
    visit system_admins_user_admins_url
    click_on "New user admin"

    check "Admin" if @system_admins_user_admin.admin
    fill_in "Email", with: @system_admins_user_admin.email
    fill_in "Full name", with: @system_admins_user_admin.full_name
    fill_in "Phone", with: @system_admins_user_admin.phone
    click_on "Create User admin"

    assert_text "User admin was successfully created"
    click_on "Back"
  end

  test "should update User admin" do
    visit system_admins_user_admin_url(@system_admins_user_admin)
    click_on "Edit this user admin", match: :first

    check "Admin" if @system_admins_user_admin.admin
    fill_in "Email", with: @system_admins_user_admin.email
    fill_in "Full name", with: @system_admins_user_admin.full_name
    fill_in "Phone", with: @system_admins_user_admin.phone
    click_on "Update User admin"

    assert_text "User admin was successfully updated"
    click_on "Back"
  end

  test "should destroy User admin" do
    visit system_admins_user_admin_url(@system_admins_user_admin)
    click_on "Destroy this user admin", match: :first

    assert_text "User admin was successfully destroyed"
  end
end
