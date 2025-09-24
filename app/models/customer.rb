class Customer < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, presence: true, format: { with: /\A[0-9\-\+\(\)\s]+\z/ }
  validates :address, length: { maximum: 500 }
  validates :company, length: { maximum: 100 }
  validates :notes, length: { maximum: 1000 }

  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_email, ->(email) { where("email LIKE ?", "%#{email}%") if email.present? }
  scope :search_by_company, ->(company) { where("company LIKE ?", "%#{company}%") if company.present? }
end
