require "test_helper"

class PackageCompositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @package_composition = package_compositions(:one)
  end

  test "should get index" do
    get package_compositions_url
    assert_response :success
  end

  test "should get new" do
    get new_package_composition_url
    assert_response :success
  end

  test "should create package_composition" do
    assert_difference("PackageComposition.count") do
      post package_compositions_url, params: { package_composition: {  discount: @package_composition. discount,  package_id: @package_composition. package_id,  price: @package_composition. price,  product_id: @package_composition. product_id,  subprice: @package_composition. subprice,  weight: @package_composition. weight } }
    end

    assert_redirected_to package_composition_url(PackageComposition.last)
  end

  test "should show package_composition" do
    get package_composition_url(@package_composition)
    assert_response :success
  end

  test "should get edit" do
    get edit_package_composition_url(@package_composition)
    assert_response :success
  end

  test "should update package_composition" do
    patch package_composition_url(@package_composition), params: { package_composition: {  discount: @package_composition. discount,  package_id: @package_composition. package_id,  price: @package_composition. price,  product_id: @package_composition. product_id,  subprice: @package_composition. subprice,  weight: @package_composition. weight } }
    assert_redirected_to package_composition_url(@package_composition)
  end

  test "should destroy package_composition" do
    assert_difference("PackageComposition.count", -1) do
      delete package_composition_url(@package_composition)
    end

    assert_redirected_to package_compositions_url
  end
end
