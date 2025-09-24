class Staff < ApplicationRecord
  belongs_to :store

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :employee_id, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :position, presence: true, length: { maximum: 50 }
  validates :department, length: { maximum: 50 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, format: { with: /\A[0-9\-\+\(\)\s]+\z/ }, allow_blank: true
  validates :hire_date, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }
  validates :is_active, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_employee_id, ->(id) { where("employee_id LIKE ?", "%#{id}%") if id.present? }
  scope :search_by_position, ->(position) { where("position LIKE ?", "%#{position}%") if position.present? }
  scope :search_by_department, ->(department) { where("department LIKE ?", "%#{department}%") if department.present? }
  scope :by_store, ->(store_id) { where(store_id: store_id) if store_id.present? }

  def status_text
    is_active? ? "在籍中" : "退職済"
  end

  def contact_info
    contact = []
    contact << "電話: #{phone}" if phone.present?
    contact << "メール: #{email}" if email.present?
    contact.join(" | ")
  end

  def full_info
    info = [name]
    info << "(#{employee_id})" if employee_id.present?
    info << "- #{position}"
    info << "at #{store.name}" if store.present?
    info.join(" ")
  end

  def formatted_salary
    "¥#{salary.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  end

  def years_of_service
    return 0 unless hire_date
    ((Date.current - hire_date) / 365.25).floor
  end
end
