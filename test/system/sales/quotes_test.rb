require "application_system_test_case"

class Sales::QuotesTest < ApplicationSystemTestCase
  setup do
    @sales_quote = sales_quotes(:one)
  end

  test "visiting the index" do
    visit sales_quotes_url
    assert_selector "h1", text: "Quotes"
  end

  test "should create quote" do
    visit sales_quotes_url
    click_on "New quote"

    fill_in "Bank slip cost", with: @sales_quote. bank_slip_cost
    fill_in "Card cost", with: @sales_quote. card_cost
    fill_in "Channel cost", with: @sales_quote. channel_cost
    fill_in "Client", with: @sales_quote. client_id
    fill_in "Status", with: @sales_quote. status
    fill_in "Total", with: @sales_quote. total
    click_on "Create Quote"

    assert_text "Quote was successfully created"
    click_on "Back"
  end

  test "should update Quote" do
    visit sales_quote_url(@sales_quote)
    click_on "Edit this quote", match: :first

    fill_in "Bank slip cost", with: @sales_quote. bank_slip_cost
    fill_in "Card cost", with: @sales_quote. card_cost
    fill_in "Channel cost", with: @sales_quote. channel_cost
    fill_in "Client", with: @sales_quote. client_id
    fill_in "Status", with: @sales_quote. status
    fill_in "Total", with: @sales_quote. total
    click_on "Update Quote"

    assert_text "Quote was successfully updated"
    click_on "Back"
  end

  test "should destroy Quote" do
    visit sales_quote_url(@sales_quote)
    click_on "Destroy this quote", match: :first

    assert_text "Quote was successfully destroyed"
  end
end
