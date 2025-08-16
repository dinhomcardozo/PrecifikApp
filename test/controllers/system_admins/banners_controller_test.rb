require "test_helper"

class SystemAdmins::BannersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_banner = system_admins_banners(:one)
  end

  test "should get index" do
    get system_admins_banners_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_banner_url
    assert_response :success
  end

  test "should create system_admins_banner" do
    assert_difference("SystemAdmins::Banner.count") do
      post system_admins_banners_url, params: { system_admins_banner: { end_date: @system_admins_banner.end_date, image: @system_admins_banner.image, link: @system_admins_banner.link, start_date: @system_admins_banner.start_date } }
    end

    assert_redirected_to system_admins_banner_url(SystemAdmins::Banner.last)
  end

  test "should show system_admins_banner" do
    get system_admins_banner_url(@system_admins_banner)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_banner_url(@system_admins_banner)
    assert_response :success
  end

  test "should update system_admins_banner" do
    patch system_admins_banner_url(@system_admins_banner), params: { system_admins_banner: { end_date: @system_admins_banner.end_date, image: @system_admins_banner.image, link: @system_admins_banner.link, start_date: @system_admins_banner.start_date } }
    assert_redirected_to system_admins_banner_url(@system_admins_banner)
  end

  test "should destroy system_admins_banner" do
    assert_difference("SystemAdmins::Banner.count", -1) do
      delete system_admins_banner_url(@system_admins_banner)
    end

    assert_redirected_to system_admins_banners_url
  end
end
