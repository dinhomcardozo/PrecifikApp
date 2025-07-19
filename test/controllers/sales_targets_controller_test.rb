require "test_helper"

class SalesTargetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_target = sales_targets(:one)
  end

  test "should get index" do
    get sales_targets_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_target_url
    assert_response :success
  end

  test "should create sales_target" do
    assert_difference("SalesTarget.count") do
      post sales_targets_url, params: { sales_target: { channel_id: @sales_target.channel_id, end_date: @sales_target.end_date, monthly_target: @sales_target.monthly_target, package_id: @sales_target.package_id, start_date: @sales_target.start_date } }
    end

    assert_redirected_to sales_target_url(SalesTarget.last)
  end

  test "should show sales_target" do
    get sales_target_url(@sales_target)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_target_url(@sales_target)
    assert_response :success
  end

  test "should update sales_target" do
    patch sales_target_url(@sales_target), params: { sales_target: { channel_id: @sales_target.channel_id, end_date: @sales_target.end_date, monthly_target: @sales_target.monthly_target, package_id: @sales_target.package_id, start_date: @sales_target.start_date } }
    assert_redirected_to sales_target_url(@sales_target)
  end

  test "should destroy sales_target" do
    assert_difference("SalesTarget.count", -1) do
      delete sales_target_url(@sales_target)
    end

    assert_redirected_to sales_targets_url
  end
end
