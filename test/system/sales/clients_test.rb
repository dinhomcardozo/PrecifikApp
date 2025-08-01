require "application_system_test_case"

class Sales::ClientsTest < ApplicationSystemTestCase
  setup do
    @sales_client = sales_clients(:one)
  end

  test "visiting the index" do
    visit sales_clients_url
    assert_selector "h1", text: "Clients"
  end

  test "should create client" do
    visit sales_clients_url
    click_on "New client"

    fill_in "Address", with: @sales_client.address
    fill_in "City", with: @sales_client.city
    fill_in "Cnpj", with: @sales_client.cnpj
    fill_in "Company", with: @sales_client.company
    fill_in "Country", with: @sales_client.country
    fill_in "Email", with: @sales_client.email
    fill_in "First name", with: @sales_client.first_name
    fill_in "Last name", with: @sales_client.last_name
    fill_in "Number address", with: @sales_client.number_address
    fill_in "Phone", with: @sales_client.phone
    fill_in "State", with: @sales_client.state
    click_on "Create Client"

    assert_text "Client was successfully created"
    click_on "Back"
  end

  test "should update Client" do
    visit sales_client_url(@sales_client)
    click_on "Edit this client", match: :first

    fill_in "Address", with: @sales_client.address
    fill_in "City", with: @sales_client.city
    fill_in "Cnpj", with: @sales_client.cnpj
    fill_in "Company", with: @sales_client.company
    fill_in "Country", with: @sales_client.country
    fill_in "Email", with: @sales_client.email
    fill_in "First name", with: @sales_client.first_name
    fill_in "Last name", with: @sales_client.last_name
    fill_in "Number address", with: @sales_client.number_address
    fill_in "Phone", with: @sales_client.phone
    fill_in "State", with: @sales_client.state
    click_on "Update Client"

    assert_text "Client was successfully updated"
    click_on "Back"
  end

  test "should destroy Client" do
    visit sales_client_url(@sales_client)
    click_on "Destroy this client", match: :first

    assert_text "Client was successfully destroyed"
  end
end
