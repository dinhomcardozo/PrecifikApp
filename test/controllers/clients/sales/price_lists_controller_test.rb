require "test_helper"

class Clients::Sales::PriceListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clients_sales_price_lists_index_url
    assert_response :success
  end

  test "should get show" do
    get clients_sales_price_lists_show_url
    assert_response :success
  end

  test "should get new" do
    get clients_sales_price_lists_new_url
    assert_response :success
  end

  test "should get edit" do
    get clients_sales_price_lists_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get clients_sales_price_lists_destroy_url
    assert_response :success
  end
end
