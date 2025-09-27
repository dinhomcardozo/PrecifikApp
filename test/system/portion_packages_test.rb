require "application_system_test_case"

class PortionPackagesTest < ApplicationSystemTestCase
  setup do
    @portion_package = portion_packages(:one)
  end

  test "visiting the index" do
    visit portion_packages_url
    assert_selector "h1", text: "Portion packages"
  end

  test "should create portion package" do
    visit portion_packages_url
    click_on "New portion package"

    fill_in "Package", with: @portion_package.package_id
    fill_in "Package units", with: @portion_package.package_units
    fill_in "Product portion", with: @portion_package.product_portion_id
    fill_in "Total package price", with: @portion_package.total_package_price
    click_on "Create Portion package"

    assert_text "Portion package was successfully created"
    click_on "Back"
  end

  test "should update Portion package" do
    visit portion_package_url(@portion_package)
    click_on "Edit this portion package", match: :first

    fill_in "Package", with: @portion_package.package_id
    fill_in "Package units", with: @portion_package.package_units
    fill_in "Product portion", with: @portion_package.product_portion_id
    fill_in "Total package price", with: @portion_package.total_package_price
    click_on "Update Portion package"

    assert_text "Portion package was successfully updated"
    click_on "Back"
  end

  test "should destroy Portion package" do
    visit portion_package_url(@portion_package)
    click_on "Destroy this portion package", match: :first

    assert_text "Portion package was successfully destroyed"
  end
end
