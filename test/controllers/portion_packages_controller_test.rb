require "test_helper"

class PortionPackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portion_package = portion_packages(:one)
  end

  test "should get index" do
    get portion_packages_url
    assert_response :success
  end

  test "should get new" do
    get new_portion_package_url
    assert_response :success
  end

  test "should create portion_package" do
    assert_difference("PortionPackage.count") do
      post portion_packages_url, params: { portion_package: { package_id: @portion_package.package_id, package_units: @portion_package.package_units, product_portion_id: @portion_package.product_portion_id, total_package_price: @portion_package.total_package_price } }
    end

    assert_redirected_to portion_package_url(PortionPackage.last)
  end

  test "should show portion_package" do
    get portion_package_url(@portion_package)
    assert_response :success
  end

  test "should get edit" do
    get edit_portion_package_url(@portion_package)
    assert_response :success
  end

  test "should update portion_package" do
    patch portion_package_url(@portion_package), params: { portion_package: { package_id: @portion_package.package_id, package_units: @portion_package.package_units, product_portion_id: @portion_package.product_portion_id, total_package_price: @portion_package.total_package_price } }
    assert_redirected_to portion_package_url(@portion_package)
  end

  test "should destroy portion_package" do
    assert_difference("PortionPackage.count", -1) do
      delete portion_package_url(@portion_package)
    end

    assert_redirected_to portion_packages_url
  end
end
