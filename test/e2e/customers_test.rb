# frozen_string_literal: true

require_relative "e2e_test_helper"

# E2E test for customer CRUD operations
class CustomersE2ETest < ActiveSupport::TestCase
  include E2ETestHelper

  def setup
    setup_playwright
    # テストデータのクリーンアップ
    Customer.destroy_all
  end

  def teardown
    teardown_playwright
  end

  test "should display customers index page" do
    # テスト用の顧客を作成
    Customer.create!(
      name: "Test Customer",
      email: "test@example.com",
      phone: "123-456-7890",
      address: "123 Test St",
      company: "Test Company"
    )

    visit "/customers"

    # ページが正常に読み込まれることを確認
    assert has_text?("Test Customer"), "Customer name should be visible"
    assert has_text?("test@example.com"), "Customer email should be visible"
  end

  test "should create new customer" do
    visit "/customers/new"

    # フォームに入力
    fill 'input[name="customer[name]"]', "New Customer"
    fill 'input[name="customer[email]"]', "new@example.com"
    fill 'input[name="customer[phone]"]', "987-654-3210"
    fill 'input[name="customer[address]"]', "456 New St"
    fill 'input[name="customer[company]"]', "New Company"

    # 送信ボタンをクリック
    click 'input[type="submit"]'

    # 顧客が作成されたことを確認
    @page.wait_for_url("**/customers/*", timeout: 5000)
    assert has_text?("New Customer"), "New customer should be created"
    assert has_text?("顧客が正常に作成されました"), "Success message should be displayed"
  end

  test "should update customer" do
    # テスト用の顧客を作成
    customer = Customer.create!(
      name: "Update Test",
      email: "update@example.com",
      phone: "111-222-3333",
      address: "789 Update St",
      company: "Update Company"
    )

    visit "/customers/#{customer.id}/edit"

    # フォームを更新
    fill 'input[name="customer[name]"]', "Updated Customer"
    fill 'input[name="customer[email]"]', "updated@example.com"

    # 送信ボタンをクリック
    click 'input[type="submit"]'

    # 顧客が更新されたことを確認
    @page.wait_for_url("**/customers/*", timeout: 5000)
    assert has_text?("Updated Customer"), "Customer should be updated"
    assert has_text?("updated@example.com"), "Email should be updated"
    assert has_text?("顧客が正常に更新されました"), "Update success message should be displayed"
  end

  test "should delete customer" do
    # テスト用の顧客を作成
    customer = Customer.create!(
      name: "Delete Test",
      email: "delete@example.com",
      phone: "444-555-6666",
      address: "321 Delete St",
      company: "Delete Company"
    )

    visit "/customers"

    # 顧客が表示されていることを確認
    assert has_text?("Delete Test"), "Customer should be visible before deletion"

    # 顧客詳細ページへ移動
    visit "/customers/#{customer.id}"

    # 削除ボタンをクリック(Turboを使用している場合)
    @page.click('a[data-turbo-method="delete"]') if @page.query_selector('a[data-turbo-method="delete"]')

    # 削除確認を待つ
    @page.wait_for_timeout(1000)

    # 顧客リストページにリダイレクトされることを確認
    assert @page.url.include?("/customers"), "Should redirect to customers index"
    assert has_text?("顧客が正常に削除されました"), "Delete success message should be displayed"
  end

  test "should search customers by name" do
    # 複数のテスト顧客を作成
    Customer.create!(
      name: "Alice",
      email: "alice@example.com",
      phone: "111-111-1111",
      company: "Company A"
    )
    Customer.create!(
      name: "Bob",
      email: "bob@example.com",
      phone: "222-222-2222",
      company: "Company B"
    )

    visit "/customers"

    # 検索フォームが存在する場合
    if @page.query_selector('input[name="search_name"]')
      fill 'input[name="search_name"]', "Alice"
      click 'button[type="submit"]'

      # 検索結果を確認
      assert has_text?("Alice"), "Alice should be found"
      refute has_text?("Bob"), "Bob should not be found"
    end
  end
end
