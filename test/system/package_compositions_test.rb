require "application_system_test_case"

class PackageCompositionsTest < ApplicationSystemTestCase
  setup do
    @package_composition = package_compositions(:one)
  end

  test "visiting the index" do
    visit package_compositions_url
    assert_selector "h1", text: "Package compositions"
  end

  test "should create package composition" do
    visit package_compositions_url
    click_on "New package composition"

    fill_in "Discount", with: @package_composition. discount
    fill_in "Package", with: @package_composition. package_id
    fill_in "Price", with: @package_composition. price
    fill_in "Product", with: @package_composition. product_id
    fill_in "Subprice", with: @package_composition. subprice
    fill_in "Weight", with: @package_composition. weight
    click_on "Create Package composition"

    assert_text "Package composition was successfully created"
    click_on "Back"
  end

  test "should update Package composition" do
    visit package_composition_url(@package_composition)
    click_on "Edit this package composition", match: :first

    fill_in "Discount", with: @package_composition. discount
    fill_in "Package", with: @package_composition. package_id
    fill_in "Price", with: @package_composition. price
    fill_in "Product", with: @package_composition. product_id
    fill_in "Subprice", with: @package_composition. subprice
    fill_in "Weight", with: @package_composition. weight
    click_on "Update Package composition"

    assert_text "Package composition was successfully updated"
    click_on "Back"
  end

  test "should destroy Package composition" do
    visit package_composition_url(@package_composition)
    click_on "Destroy this package composition", match: :first

    assert_text "Package composition was successfully destroyed"
  end
end
