class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :category, presence: true, length: { maximum: 50 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :is_active, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_category, ->(category) { where("category LIKE ?", "%#{category}%") if category.present? }
  scope :search_by_sku, ->(sku) { where("sku LIKE ?", "%#{sku}%") if sku.present? }
  scope :in_stock, -> { where("stock_quantity > 0") }
  scope :out_of_stock, -> { where(stock_quantity: 0) }

  def formatted_price
    "¥#{price.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  end

  def stock_status
    return "在庫切れ" if stock_quantity == 0
    return "在庫少" if stock_quantity <= 5
    "在庫あり"
  end

  def status_text
    is_active? ? "販売中" : "販売停止"
  end
end
