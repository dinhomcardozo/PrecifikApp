require "application_system_test_case"

class TaxProfilesTest < ApplicationSystemTestCase
  setup do
    @tax_profile = tax_profiles(:one)
  end

  test "visiting the index" do
    visit tax_profiles_url
    assert_selector "h1", text: "Tax profiles"
  end

  test "should create tax profile" do
    visit tax_profiles_url
    click_on "New tax profile"

    check "Active" if @tax_profile.active
    fill_in "Description", with: @tax_profile.description
    click_on "Create Tax profile"

    assert_text "Tax profile was successfully created"
    click_on "Back"
  end

  test "should update Tax profile" do
    visit tax_profile_url(@tax_profile)
    click_on "Edit this tax profile", match: :first

    check "Active" if @tax_profile.active
    fill_in "Description", with: @tax_profile.description
    click_on "Update Tax profile"

    assert_text "Tax profile was successfully updated"
    click_on "Back"
  end

  test "should destroy Tax profile" do
    visit tax_profile_url(@tax_profile)
    click_on "Destroy this tax profile", match: :first

    assert_text "Tax profile was successfully destroyed"
  end
end
