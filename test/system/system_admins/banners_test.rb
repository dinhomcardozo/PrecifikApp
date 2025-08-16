require "application_system_test_case"

class SystemAdmins::BannersTest < ApplicationSystemTestCase
  setup do
    @system_admins_banner = system_admins_banners(:one)
  end

  test "visiting the index" do
    visit system_admins_banners_url
    assert_selector "h1", text: "Banners"
  end

  test "should create banner" do
    visit system_admins_banners_url
    click_on "New banner"

    fill_in "End date", with: @system_admins_banner.end_date
    fill_in "Image", with: @system_admins_banner.image
    fill_in "Link", with: @system_admins_banner.link
    fill_in "Start date", with: @system_admins_banner.start_date
    click_on "Create Banner"

    assert_text "Banner was successfully created"
    click_on "Back"
  end

  test "should update Banner" do
    visit system_admins_banner_url(@system_admins_banner)
    click_on "Edit this banner", match: :first

    fill_in "End date", with: @system_admins_banner.end_date
    fill_in "Image", with: @system_admins_banner.image
    fill_in "Link", with: @system_admins_banner.link
    fill_in "Start date", with: @system_admins_banner.start_date
    click_on "Update Banner"

    assert_text "Banner was successfully updated"
    click_on "Back"
  end

  test "should destroy Banner" do
    visit system_admins_banner_url(@system_admins_banner)
    click_on "Destroy this banner", match: :first

    assert_text "Banner was successfully destroyed"
  end
end
