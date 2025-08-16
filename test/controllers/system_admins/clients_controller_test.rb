require "test_helper"

class SystemAdmins::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admins_client = system_admins_clients(:one)
  end

  test "should get index" do
    get system_admins_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_system_admins_client_url
    assert_response :success
  end

  test "should create system_admins_client" do
    assert_difference("SystemAdmins::Client.count") do
      post system_admins_clients_url, params: { system_admins_client: { address: @system_admins_client.address, cnpj: @system_admins_client.cnpj, company_name: @system_admins_client.company_name, cpf: @system_admins_client.cpf, first_login: @system_admins_client.first_login, first_name: @system_admins_client.first_name, first_payment: @system_admins_client.first_payment, last_login: @system_admins_client.last_login, last_name: @system_admins_client.last_name, last_payment: @system_admins_client.last_payment, number_address: @system_admins_client.number_address, phone: @system_admins_client.phone, plan_id: @system_admins_client.plan_id, razao_social: @system_admins_client.razao_social, signup_date: @system_admins_client.signup_date } }
    end

    assert_redirected_to system_admins_client_url(SystemAdmins::Client.last)
  end

  test "should show system_admins_client" do
    get system_admins_client_url(@system_admins_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_admins_client_url(@system_admins_client)
    assert_response :success
  end

  test "should update system_admins_client" do
    patch system_admins_client_url(@system_admins_client), params: { system_admins_client: { address: @system_admins_client.address, cnpj: @system_admins_client.cnpj, company_name: @system_admins_client.company_name, cpf: @system_admins_client.cpf, first_login: @system_admins_client.first_login, first_name: @system_admins_client.first_name, first_payment: @system_admins_client.first_payment, last_login: @system_admins_client.last_login, last_name: @system_admins_client.last_name, last_payment: @system_admins_client.last_payment, number_address: @system_admins_client.number_address, phone: @system_admins_client.phone, plan_id: @system_admins_client.plan_id, razao_social: @system_admins_client.razao_social, signup_date: @system_admins_client.signup_date } }
    assert_redirected_to system_admins_client_url(@system_admins_client)
  end

  test "should destroy system_admins_client" do
    assert_difference("SystemAdmins::Client.count", -1) do
      delete system_admins_client_url(@system_admins_client)
    end

    assert_redirected_to system_admins_clients_url
  end
end
