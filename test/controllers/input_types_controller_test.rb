require "test_helper"

class InputTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get input_types_index_url
    assert_response :success
  end

  test "should get show" do
    get input_types_show_url
    assert_response :success
  end

  test "should get new" do
    get input_types_new_url
    assert_response :success
  end

  test "should get edit" do
    get input_types_edit_url
    assert_response :success
  end
end
