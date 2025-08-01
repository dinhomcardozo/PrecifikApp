require "test_helper"

class Sales::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_client = sales_clients(:one)
  end

  test "should get index" do
    get sales_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_client_url
    assert_response :success
  end

  test "should create sales_client" do
    assert_difference("Sales::Client.count") do
      post sales_clients_url, params: { sales_client: { address: @sales_client.address, city: @sales_client.city, cnpj: @sales_client.cnpj, company: @sales_client.company, country: @sales_client.country, email: @sales_client.email, first_name: @sales_client.first_name, last_name: @sales_client.last_name, number_address: @sales_client.number_address, phone: @sales_client.phone, state: @sales_client.state } }
    end

    assert_redirected_to sales_client_url(Sales::Client.last)
  end

  test "should show sales_client" do
    get sales_client_url(@sales_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_client_url(@sales_client)
    assert_response :success
  end

  test "should update sales_client" do
    patch sales_client_url(@sales_client), params: { sales_client: { address: @sales_client.address, city: @sales_client.city, cnpj: @sales_client.cnpj, company: @sales_client.company, country: @sales_client.country, email: @sales_client.email, first_name: @sales_client.first_name, last_name: @sales_client.last_name, number_address: @sales_client.number_address, phone: @sales_client.phone, state: @sales_client.state } }
    assert_redirected_to sales_client_url(@sales_client)
  end

  test "should destroy sales_client" do
    assert_difference("Sales::Client.count", -1) do
      delete sales_client_url(@sales_client)
    end

    assert_redirected_to sales_clients_url
  end
end
