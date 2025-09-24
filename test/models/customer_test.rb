require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    customer = Customer.new(
      name: "田中太郎",
      email: "tanaka@example.com",
      phone: "03-1234-5678",
      address: "東京都渋谷区渋谷1-1-1"
    )
    assert customer.valid?
  end

  test "should require name" do
    customer = Customer.new(email: "test@example.com")
    assert_not customer.valid?
    assert_includes customer.errors[:name], "can't be blank"
  end

  test "should require minimum name length" do
    customer = Customer.new(name: "a")
    assert_not customer.valid?
    assert_includes customer.errors[:name], "is too short (minimum is 2 characters)"
  end

  test "should validate email format" do
    customer = Customer.new(name: "Test", email: "invalid_email")
    assert_not customer.valid?
    assert_includes customer.errors[:email], "is invalid"
  end

  test "should validate phone format" do
    customer = Customer.new(name: "Test", phone: "invalid_phone")
    assert_not customer.valid?
    assert_includes customer.errors[:phone], "is invalid"
  end

  test "should search by name" do
    customer1 = Customer.create!(name: "田中太郎", email: "tanaka@example.com")
    customer2 = Customer.create!(name: "佐藤花子", email: "sato@example.com")

    results = Customer.search_by_name("田中")
    assert_includes results, customer1
    assert_not_includes results, customer2
  end

  test "should search by email" do
    customer1 = Customer.create!(name: "田中太郎", email: "tanaka@example.com")
    customer2 = Customer.create!(name: "佐藤花子", email: "sato@example.com")

    results = Customer.search_by_email("tanaka")
    assert_includes results, customer1
    assert_not_includes results, customer2
  end

  test "should format age display" do
    customer = Customer.new(age: 25)
    assert_equal "25歳", customer.age_display

    customer.age = nil
    assert_equal "未設定", customer.age_display
  end

  test "should provide full contact info" do
    customer = Customer.new(
      name: "田中太郎",
      email: "tanaka@example.com",
      phone: "03-1234-5678"
    )
    expected = "田中太郎 - 電話: 03-1234-5678 | メール: tanaka@example.com"
    assert_equal expected, customer.full_contact_info
  end
end
