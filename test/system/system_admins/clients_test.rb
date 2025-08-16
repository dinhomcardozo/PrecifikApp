require "application_system_test_case"

class SystemAdmins::ClientsTest < ApplicationSystemTestCase
  setup do
    @system_admins_client = system_admins_clients(:one)
  end

  test "visiting the index" do
    visit system_admins_clients_url
    assert_selector "h1", text: "Clients"
  end

  test "should create client" do
    visit system_admins_clients_url
    click_on "New client"

    fill_in "Address", with: @system_admins_client.address
    fill_in "Cnpj", with: @system_admins_client.cnpj
    fill_in "Company name", with: @system_admins_client.company_name
    fill_in "Cpf", with: @system_admins_client.cpf
    fill_in "First login", with: @system_admins_client.first_login
    fill_in "First name", with: @system_admins_client.first_name
    fill_in "First payment", with: @system_admins_client.first_payment
    fill_in "Last login", with: @system_admins_client.last_login
    fill_in "Last name", with: @system_admins_client.last_name
    fill_in "Last payment", with: @system_admins_client.last_payment
    fill_in "Number address", with: @system_admins_client.number_address
    fill_in "Phone", with: @system_admins_client.phone
    fill_in "Plan", with: @system_admins_client.plan_id
    fill_in "Razao social", with: @system_admins_client.razao_social
    fill_in "Signup date", with: @system_admins_client.signup_date
    click_on "Create Client"

    assert_text "Client was successfully created"
    click_on "Back"
  end

  test "should update Client" do
    visit system_admins_client_url(@system_admins_client)
    click_on "Edit this client", match: :first

    fill_in "Address", with: @system_admins_client.address
    fill_in "Cnpj", with: @system_admins_client.cnpj
    fill_in "Company name", with: @system_admins_client.company_name
    fill_in "Cpf", with: @system_admins_client.cpf
    fill_in "First login", with: @system_admins_client.first_login.to_s
    fill_in "First name", with: @system_admins_client.first_name
    fill_in "First payment", with: @system_admins_client.first_payment
    fill_in "Last login", with: @system_admins_client.last_login.to_s
    fill_in "Last name", with: @system_admins_client.last_name
    fill_in "Last payment", with: @system_admins_client.last_payment
    fill_in "Number address", with: @system_admins_client.number_address
    fill_in "Phone", with: @system_admins_client.phone
    fill_in "Plan", with: @system_admins_client.plan_id
    fill_in "Razao social", with: @system_admins_client.razao_social
    fill_in "Signup date", with: @system_admins_client.signup_date
    click_on "Update Client"

    assert_text "Client was successfully updated"
    click_on "Back"
  end

  test "should destroy Client" do
    visit system_admins_client_url(@system_admins_client)
    click_on "Destroy this client", match: :first

    assert_text "Client was successfully destroyed"
  end
end
