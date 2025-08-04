require "application_system_test_case"

class ServicesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "visiting the index" do
    visit services_url
    assert_selector "h1", text: "Services"
  end

  test "should create service" do
    visit services_url
    click_on "New service"

    fill_in "Description", with: @service. description
    fill_in "Final price", with: @service. final_price
    fill_in "Profit margin percent", with: @service. profit_margin_percent
    fill_in "Role", with: @service. role_id
    fill_in "Tax percent", with: @service. tax_percent
    fill_in "Total seconds", with: @service. total_seconds
    click_on "Create Service"

    assert_text "Service was successfully created"
    click_on "Back"
  end

  test "should update Service" do
    visit service_url(@service)
    click_on "Edit this service", match: :first

    fill_in "Description", with: @service. description
    fill_in "Final price", with: @service. final_price
    fill_in "Profit margin percent", with: @service. profit_margin_percent
    fill_in "Role", with: @service. role_id
    fill_in "Tax percent", with: @service. tax_percent
    fill_in "Total seconds", with: @service. total_seconds
    click_on "Update Service"

    assert_text "Service was successfully updated"
    click_on "Back"
  end

  test "should destroy Service" do
    visit service_url(@service)
    click_on "Destroy this service", match: :first

    assert_text "Service was successfully destroyed"
  end
end
