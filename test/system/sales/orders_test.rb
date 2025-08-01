require "application_system_test_case"

class Sales::OrdersTest < ApplicationSystemTestCase
  setup do
    @sales_order = sales_orders(:one)
  end

  test "visiting the index" do
    visit sales_orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    visit sales_orders_url
    click_on "New order"

    fill_in "Placed at", with: @sales_order.placed_at
    fill_in "Sales quote", with: @sales_order.sales_quote_id
    fill_in "Status", with: @sales_order.status
    fill_in "Total", with: @sales_order.total
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "should update Order" do
    visit sales_order_url(@sales_order)
    click_on "Edit this order", match: :first

    fill_in "Placed at", with: @sales_order.placed_at.to_s
    fill_in "Sales quote", with: @sales_order.sales_quote_id
    fill_in "Status", with: @sales_order.status
    fill_in "Total", with: @sales_order.total
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit sales_order_url(@sales_order)
    click_on "Destroy this order", match: :first

    assert_text "Order was successfully destroyed"
  end
end
