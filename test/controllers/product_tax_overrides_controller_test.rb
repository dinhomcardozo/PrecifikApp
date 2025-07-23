require "test_helper"

class ProductTaxOverridesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_tax_override = product_tax_overrides(:one)
  end

  test "should get index" do
    get product_tax_overrides_url
    assert_response :success
  end

  test "should get new" do
    get new_product_tax_override_url
    assert_response :success
  end

  test "should create product_tax_override" do
    assert_difference("ProductTaxOverride.count") do
      post product_tax_overrides_url, params: { product_tax_override: { name: @product_tax_override.name, product_id: @product_tax_override.product_id, tax_type: @product_tax_override.tax_type, value: @product_tax_override.value } }
    end

    assert_redirected_to product_tax_override_url(ProductTaxOverride.last)
  end

  test "should show product_tax_override" do
    get product_tax_override_url(@product_tax_override)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_tax_override_url(@product_tax_override)
    assert_response :success
  end

  test "should update product_tax_override" do
    patch product_tax_override_url(@product_tax_override), params: { product_tax_override: { name: @product_tax_override.name, product_id: @product_tax_override.product_id, tax_type: @product_tax_override.tax_type, value: @product_tax_override.value } }
    assert_redirected_to product_tax_override_url(@product_tax_override)
  end

  test "should destroy product_tax_override" do
    assert_difference("ProductTaxOverride.count", -1) do
      delete product_tax_override_url(@product_tax_override)
    end

    assert_redirected_to product_tax_overrides_url
  end
end
