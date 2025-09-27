require "application_system_test_case"

class ProductPortionsTest < ApplicationSystemTestCase
  setup do
    @product_portion = product_portions(:one)
  end

  test "visiting the index" do
    visit product_portions_url
    assert_selector "h1", text: "Product portions"
  end

  test "should create product portion" do
    visit product_portions_url
    click_on "New product portion"

    check "Active" if @product_portion.active
    fill_in "Final package price", with: @product_portion.final_package_price
    fill_in "Portioned quantity", with: @product_portion.portioned_quantity
    fill_in "Product", with: @product_portion.product_id
    click_on "Create Product portion"

    assert_text "Product portion was successfully created"
    click_on "Back"
  end

  test "should update Product portion" do
    visit product_portion_url(@product_portion)
    click_on "Edit this product portion", match: :first

    check "Active" if @product_portion.active
    fill_in "Final package price", with: @product_portion.final_package_price
    fill_in "Portioned quantity", with: @product_portion.portioned_quantity
    fill_in "Product", with: @product_portion.product_id
    click_on "Update Product portion"

    assert_text "Product portion was successfully updated"
    click_on "Back"
  end

  test "should destroy Product portion" do
    visit product_portion_url(@product_portion)
    click_on "Destroy this product portion", match: :first

    assert_text "Product portion was successfully destroyed"
  end
end
