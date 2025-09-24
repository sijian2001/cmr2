require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @customer = customers(:one)
    sign_in @user
  end

  test "should get index" do
    get customers_url
    assert_response :success
    assert_select "h1", "顧客管理"
  end

  test "should get new" do
    get new_customer_url
    assert_response :success
    assert_select "h1", "新規顧客登録"
  end

  test "should create customer" do
    assert_difference("Customer.count") do
      post customers_url, params: {
        customer: {
          name: "新規顧客",
          email: "new@example.com",
          phone: "03-1234-5678",
          address: "東京都"
        }
      }
    end

    assert_redirected_to customer_url(Customer.last)
  end

  test "should show customer" do
    get customer_url(@customer)
    assert_response :success
    assert_select "h1", @customer.name
  end

  test "should get edit" do
    get edit_customer_url(@customer)
    assert_response :success
    assert_select "h1", "顧客編集"
  end

  test "should update customer" do
    patch customer_url(@customer), params: {
      customer: {
        name: "更新された顧客",
        email: @customer.email
      }
    }
    assert_redirected_to customer_url(@customer)

    @customer.reload
    assert_equal "更新された顧客", @customer.name
  end

  test "should destroy customer" do
    assert_difference("Customer.count", -1) do
      delete customer_url(@customer)
    end

    assert_redirected_to customers_url
  end

  test "should search customers by name" do
    get customers_url, params: { search_name: @customer.name.first(2) }
    assert_response :success
  end

  test "should search customers by email" do
    get customers_url, params: { search_email: @customer.email.split("@").first }
    assert_response :success
  end

  test "should handle invalid customer creation" do
    assert_no_difference("Customer.count") do
      post customers_url, params: {
        customer: {
          name: "",  # Invalid - empty name
          email: "invalid_email"  # Invalid format
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should require authentication" do
    sign_out @user

    get customers_url
    assert_redirected_to new_user_session_path
  end
end
