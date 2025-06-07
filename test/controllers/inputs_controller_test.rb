require "test_helper"

class InputsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get inputs_new_url
    assert_response :success
  end

  test "should get create" do
    get inputs_create_url
    assert_response :success
  end

  test "should get edit" do
    get inputs_edit_url
    assert_response :success
  end

  test "should get update" do
    get inputs_update_url
    assert_response :success
  end

  test "should get show" do
    get inputs_show_url
    assert_response :success
  end

  test "should get index" do
    get inputs_index_url
    assert_response :success
  end
end
