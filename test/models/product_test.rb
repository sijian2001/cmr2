require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    product = Product.new(
      name: "テスト商品",
      price: 1000,
      stock_quantity: 50,
      category: "テストカテゴリ"
    )
    assert product.valid?
  end

  test "should require name" do
    product = Product.new(price: 1000)
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "should require price to be positive" do
    product = Product.new(name: "Test", price: -100)
    assert_not product.valid?
    assert_includes product.errors[:price], "must be greater than 0"
  end

  test "should require stock_quantity to be non-negative" do
    product = Product.new(name: "Test", price: 100, stock_quantity: -1)
    assert_not product.valid?
    assert_includes product.errors[:stock_quantity], "must be greater than or equal to 0"
  end

  test "should format price correctly" do
    product = Product.new(price: 123456)
    assert_equal "¥123,456", product.formatted_price
  end

  test "should return correct stock status" do
    product = Product.new(stock_quantity: 0)
    assert_equal "在庫切れ", product.stock_status

    product.stock_quantity = 3
    assert_equal "在庫少", product.stock_status

    product.stock_quantity = 10
    assert_equal "在庫あり", product.stock_status
  end

  test "should search by name" do
    product1 = Product.create!(name: "テスト商品A", price: 1000, stock_quantity: 10)
    product2 = Product.create!(name: "サンプル商品B", price: 2000, stock_quantity: 20)

    results = Product.search_by_name("テスト")
    assert_includes results, product1
    assert_not_includes results, product2
  end

  test "should search by category" do
    product1 = Product.create!(name: "商品A", price: 1000, stock_quantity: 10, category: "電子機器")
    product2 = Product.create!(name: "商品B", price: 2000, stock_quantity: 20, category: "書籍")

    results = Product.search_by_category("電子")
    assert_includes results, product1
    assert_not_includes results, product2
  end

  test "should filter by stock status" do
    out_of_stock = Product.create!(name: "在庫切れ商品", price: 1000, stock_quantity: 0)
    low_stock = Product.create!(name: "在庫少商品", price: 1000, stock_quantity: 3)
    in_stock = Product.create!(name: "在庫あり商品", price: 1000, stock_quantity: 10)

    assert_includes Product.out_of_stock, out_of_stock
    assert_not_includes Product.out_of_stock, in_stock

    assert_includes Product.low_stock, low_stock
    assert_not_includes Product.low_stock, in_stock

    assert_includes Product.in_stock, in_stock
    assert_not_includes Product.in_stock, out_of_stock
  end

  test "should provide full product info" do
    product = Product.new(
      name: "テスト商品",
      category: "テストカテゴリ",
      price: 1000,
      stock_quantity: 10
    )
    expected = "テスト商品 (テストカテゴリ) - ¥1,000 - 在庫: 10個"
    assert_equal expected, product.full_product_info
  end
end
