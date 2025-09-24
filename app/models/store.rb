class Store < ApplicationRecord
  has_many :staffs, dependent: :destroy
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :address, presence: true, length: { maximum: 500 }
  validates :phone, presence: true, format: { with: /\A[0-9\-\+\(\)\s]+\z/ }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :manager_name, presence: true, length: { maximum: 50 }
  validates :opening_hours, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :is_active, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_address, ->(address) { where("address LIKE ?", "%#{address}%") if address.present? }
  scope :search_by_manager, ->(manager) { where("manager_name LIKE ?", "%#{manager}%") if manager.present? }

  def status_text
    is_active? ? "営業中" : "営業停止"
  end

  def contact_info
    contact = []
    contact << "電話: #{phone}" if phone.present?
    contact << "メール: #{email}" if email.present?
    contact.join(" | ")
  end

  def full_info
    info = [name]
    info << "(#{manager_name})" if manager_name.present?
    info << "- #{address}"
    info.join(" ")
  end
end
