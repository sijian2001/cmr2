require "test_helper"

class StoreTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    store = Store.new(
      name: "テスト店舗",
      manager_name: "田中太郎",
      address: "東京都渋谷区渋谷1-1-1",
      phone: "03-1234-5678",
      is_active: true
    )
    assert store.valid?
  end

  test "should require name" do
    store = Store.new(manager_name: "田中太郎", address: "東京", phone: "03-1234-5678")
    assert_not store.valid?
    assert_includes store.errors[:name], "can't be blank"
  end

  test "should require manager_name" do
    store = Store.new(name: "テスト店舗", address: "東京", phone: "03-1234-5678")
    assert_not store.valid?
    assert_includes store.errors[:manager_name], "can't be blank"
  end

  test "should validate phone format" do
    store = Store.new(
      name: "テスト店舗",
      manager_name: "田中太郎",
      address: "東京",
      phone: "invalid_phone"
    )
    assert_not store.valid?
    assert_includes store.errors[:phone], "is invalid"
  end

  test "should return correct status text" do
    store = Store.new(is_active: true)
    assert_equal "営業中", store.status_text

    store.is_active = false
    assert_equal "営業停止", store.status_text
  end

  test "should search by name" do
    store1 = Store.create!(name: "東京店", manager_name: "田中太郎", address: "東京", phone: "03-1234-5678")
    store2 = Store.create!(name: "大阪店", manager_name: "佐藤花子", address: "大阪", phone: "06-1234-5678")

    results = Store.search_by_name("東京")
    assert_includes results, store1
    assert_not_includes results, store2
  end

  test "should search by address" do
    store1 = Store.create!(name: "店舗A", manager_name: "田中太郎", address: "東京都渋谷区", phone: "03-1234-5678")
    store2 = Store.create!(name: "店舗B", manager_name: "佐藤花子", address: "大阪府大阪市", phone: "06-1234-5678")

    results = Store.search_by_address("渋谷")
    assert_includes results, store1
    assert_not_includes results, store2
  end

  test "should search by manager" do
    store1 = Store.create!(name: "店舗A", manager_name: "田中太郎", address: "東京", phone: "03-1234-5678")
    store2 = Store.create!(name: "店舗B", manager_name: "佐藤花子", address: "大阪", phone: "06-1234-5678")

    results = Store.search_by_manager("田中")
    assert_includes results, store1
    assert_not_includes results, store2
  end

  test "should filter by status" do
    active_store = Store.create!(name: "営業中店舗", manager_name: "田中太郎", address: "東京", phone: "03-1234-5678", is_active: true)
    inactive_store = Store.create!(name: "営業停止店舗", manager_name: "佐藤花子", address: "大阪", phone: "06-1234-5678", is_active: false)

    assert_includes Store.active, active_store
    assert_not_includes Store.active, inactive_store

    assert_includes Store.inactive, inactive_store
    assert_not_includes Store.inactive, active_store
  end

  test "should provide contact info" do
    store = Store.new(phone: "03-1234-5678", email: "test@example.com")
    expected = "電話: 03-1234-5678 | メール: test@example.com"
    assert_equal expected, store.contact_info

    store.email = nil
    expected = "電話: 03-1234-5678"
    assert_equal expected, store.contact_info
  end

  test "should provide full info" do
    store = Store.new(
      name: "テスト店舗",
      manager_name: "田中太郎",
      address: "東京都渋谷区渋谷1-1-1"
    )
    expected = "テスト店舗 (田中太郎) - 東京都渋谷区渋谷1-1-1"
    assert_equal expected, store.full_info
  end
end
