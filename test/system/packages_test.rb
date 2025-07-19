require "application_system_test_case"

class PackagesTest < ApplicationSystemTestCase
  setup do
    @package = packages(:one)
  end

  test "visiting the index" do
    visit packages_url
    assert_selector "h1", text: "Packages"
  end

  test "should create package" do
    visit packages_url
    click_on "New package"

    fill_in "Brand", with: @package. brand_id
    fill_in "Channel", with: @package. channel_id
    fill_in "Description", with: @package. description
    fill_in "Final price", with: @package. final_price
    fill_in "General discount", with: @package. general_discount
    fill_in "Subtotal price", with: @package. subtotal_price
    fill_in "Total price", with: @package. total_price
    fill_in "Total weight", with: @package. total_weight
    click_on "Create Package"

    assert_text "Package was successfully created"
    click_on "Back"
  end

  test "should update Package" do
    visit package_url(@package)
    click_on "Edit this package", match: :first

    fill_in "Brand", with: @package. brand_id
    fill_in "Channel", with: @package. channel_id
    fill_in "Description", with: @package. description
    fill_in "Final price", with: @package. final_price
    fill_in "General discount", with: @package. general_discount
    fill_in "Subtotal price", with: @package. subtotal_price
    fill_in "Total price", with: @package. total_price
    fill_in "Total weight", with: @package. total_weight
    click_on "Update Package"

    assert_text "Package was successfully updated"
    click_on "Back"
  end

  test "should destroy Package" do
    visit package_url(@package)
    click_on "Destroy this package", match: :first

    assert_text "Package was successfully destroyed"
  end
end
