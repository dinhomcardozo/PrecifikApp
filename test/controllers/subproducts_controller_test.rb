require "test_helper"

class SubproductsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get subproducts_new_url
    assert_response :success
  end

  test "should get create" do
    get subproducts_create_url
    assert_response :success
  end

  test "should get edit" do
    get subproducts_edit_url
    assert_response :success
  end

  test "should get update" do
    get subproducts_update_url
    assert_response :success
  end

  test "should get show" do
    get subproducts_show_url
    assert_response :success
  end

  test "should get index" do
    get subproducts_index_url
    assert_response :success
  end
end
