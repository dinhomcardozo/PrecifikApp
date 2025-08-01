require "test_helper"

class Sales::QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_quote = sales_quotes(:one)
  end

  test "should get index" do
    get sales_quotes_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_quote_url
    assert_response :success
  end

  test "should create sales_quote" do
    assert_difference("Sales::Quote.count") do
      post sales_quotes_url, params: { sales_quote: {  bank_slip_cost: @sales_quote. bank_slip_cost,  card_cost: @sales_quote. card_cost,  channel_cost: @sales_quote. channel_cost,  client_id: @sales_quote. client_id,  status: @sales_quote. status,  total: @sales_quote. total } }
    end

    assert_redirected_to sales_quote_url(Sales::Quote.last)
  end

  test "should show sales_quote" do
    get sales_quote_url(@sales_quote)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_quote_url(@sales_quote)
    assert_response :success
  end

  test "should update sales_quote" do
    patch sales_quote_url(@sales_quote), params: { sales_quote: {  bank_slip_cost: @sales_quote. bank_slip_cost,  card_cost: @sales_quote. card_cost,  channel_cost: @sales_quote. channel_cost,  client_id: @sales_quote. client_id,  status: @sales_quote. status,  total: @sales_quote. total } }
    assert_redirected_to sales_quote_url(@sales_quote)
  end

  test "should destroy sales_quote" do
    assert_difference("Sales::Quote.count", -1) do
      delete sales_quote_url(@sales_quote)
    end

    assert_redirected_to sales_quotes_url
  end
end
