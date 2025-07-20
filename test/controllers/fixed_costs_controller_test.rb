require "test_helper"

class FixedCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fixed_cost = fixed_costs(:one)
  end

  test "should get index" do
    get fixed_costs_url
    assert_response :success
  end

  test "should get new" do
    get new_fixed_cost_url
    assert_response :success
  end

  test "should create fixed_cost" do
    assert_difference("FixedCost.count") do
      post fixed_costs_url, params: { fixed_cost: {  description: @fixed_cost. description,  fixed_cost_type: @fixed_cost. fixed_cost_type,  monthly_cost: @fixed_cost. monthly_cost } }
    end

    assert_redirected_to fixed_cost_url(FixedCost.last)
  end

  test "should show fixed_cost" do
    get fixed_cost_url(@fixed_cost)
    assert_response :success
  end

  test "should get edit" do
    get edit_fixed_cost_url(@fixed_cost)
    assert_response :success
  end

  test "should update fixed_cost" do
    patch fixed_cost_url(@fixed_cost), params: { fixed_cost: {  description: @fixed_cost. description,  fixed_cost_type: @fixed_cost. fixed_cost_type,  monthly_cost: @fixed_cost. monthly_cost } }
    assert_redirected_to fixed_cost_url(@fixed_cost)
  end

  test "should destroy fixed_cost" do
    assert_difference("FixedCost.count", -1) do
      delete fixed_cost_url(@fixed_cost)
    end

    assert_redirected_to fixed_costs_url
  end
end
