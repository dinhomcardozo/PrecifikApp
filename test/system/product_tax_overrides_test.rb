require "application_system_test_case"

class ProductTaxOverridesTest < ApplicationSystemTestCase
  setup do
    @product_tax_override = product_tax_overrides(:one)
  end

  test "visiting the index" do
    visit product_tax_overrides_url
    assert_selector "h1", text: "Product tax overrides"
  end

  test "should create product tax override" do
    visit product_tax_overrides_url
    click_on "New product tax override"

    fill_in "Name", with: @product_tax_override.name
    fill_in "Product", with: @product_tax_override.product_id
    fill_in "Tax type", with: @product_tax_override.tax_type
    fill_in "Value", with: @product_tax_override.value
    click_on "Create Product tax override"

    assert_text "Product tax override was successfully created"
    click_on "Back"
  end

  test "should update Product tax override" do
    visit product_tax_override_url(@product_tax_override)
    click_on "Edit this product tax override", match: :first

    fill_in "Name", with: @product_tax_override.name
    fill_in "Product", with: @product_tax_override.product_id
    fill_in "Tax type", with: @product_tax_override.tax_type
    fill_in "Value", with: @product_tax_override.value
    click_on "Update Product tax override"

    assert_text "Product tax override was successfully updated"
    click_on "Back"
  end

  test "should destroy Product tax override" do
    visit product_tax_override_url(@product_tax_override)
    click_on "Destroy this product tax override", match: :first

    assert_text "Product tax override was successfully destroyed"
  end
end
