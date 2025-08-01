require "test_helper"

class Sales::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_order = sales_orders(:one)
  end

  test "should get index" do
    get sales_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_order_url
    assert_response :success
  end

  test "should create sales_order" do
    assert_difference("Sales::Order.count") do
      post sales_orders_url, params: { sales_order: { placed_at: @sales_order.placed_at, sales_quote_id: @sales_order.sales_quote_id, status: @sales_order.status, total: @sales_order.total } }
    end

    assert_redirected_to sales_order_url(Sales::Order.last)
  end

  test "should show sales_order" do
    get sales_order_url(@sales_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_order_url(@sales_order)
    assert_response :success
  end

  test "should update sales_order" do
    patch sales_order_url(@sales_order), params: { sales_order: { placed_at: @sales_order.placed_at, sales_quote_id: @sales_order.sales_quote_id, status: @sales_order.status, total: @sales_order.total } }
    assert_redirected_to sales_order_url(@sales_order)
  end

  test "should destroy sales_order" do
    assert_difference("Sales::Order.count", -1) do
      delete sales_order_url(@sales_order)
    end

    assert_redirected_to sales_orders_url
  end
end
