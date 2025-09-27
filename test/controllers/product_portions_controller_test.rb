require "test_helper"

class ProductPortionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_portion = product_portions(:one)
  end

  test "should get index" do
    get product_portions_url
    assert_response :success
  end

  test "should get new" do
    get new_product_portion_url
    assert_response :success
  end

  test "should create product_portion" do
    assert_difference("ProductPortion.count") do
      post product_portions_url, params: { product_portion: { active: @product_portion.active, final_package_price: @product_portion.final_package_price, portioned_quantity: @product_portion.portioned_quantity, product_id: @product_portion.product_id } }
    end

    assert_redirected_to product_portion_url(ProductPortion.last)
  end

  test "should show product_portion" do
    get product_portion_url(@product_portion)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_portion_url(@product_portion)
    assert_response :success
  end

  test "should update product_portion" do
    patch product_portion_url(@product_portion), params: { product_portion: { active: @product_portion.active, final_package_price: @product_portion.final_package_price, portioned_quantity: @product_portion.portioned_quantity, product_id: @product_portion.product_id } }
    assert_redirected_to product_portion_url(@product_portion)
  end

  test "should destroy product_portion" do
    assert_difference("ProductPortion.count", -1) do
      delete product_portion_url(@product_portion)
    end

    assert_redirected_to product_portions_url
  end
end
