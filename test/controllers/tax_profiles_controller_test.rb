require "test_helper"

class TaxProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tax_profile = tax_profiles(:one)
  end

  test "should get index" do
    get tax_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_tax_profile_url
    assert_response :success
  end

  test "should create tax_profile" do
    assert_difference("TaxProfile.count") do
      post tax_profiles_url, params: { tax_profile: { active: @tax_profile.active, description: @tax_profile.description } }
    end

    assert_redirected_to tax_profile_url(TaxProfile.last)
  end

  test "should show tax_profile" do
    get tax_profile_url(@tax_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_tax_profile_url(@tax_profile)
    assert_response :success
  end

  test "should update tax_profile" do
    patch tax_profile_url(@tax_profile), params: { tax_profile: { active: @tax_profile.active, description: @tax_profile.description } }
    assert_redirected_to tax_profile_url(@tax_profile)
  end

  test "should destroy tax_profile" do
    assert_difference("TaxProfile.count", -1) do
      delete tax_profile_url(@tax_profile)
    end

    assert_redirected_to tax_profiles_url
  end
end
