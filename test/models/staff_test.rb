require "test_helper"

class StaffTest < ActiveSupport::TestCase
  def setup
    @store = Store.create!(
      name: "テスト店舗",
      manager_name: "店長太郎",
      address: "東京都渋谷区渋谷1-1-1",
      phone: "03-1234-5678"
    )
  end

  test "should be valid with valid attributes" do
    staff = Staff.new(
      name: "田中花子",
      employee_id: "EMP001",
      position: "店員",
      hire_date: 1.year.ago,
      salary: 250000,
      store: @store,
      is_active: true
    )
    assert staff.valid?
  end

  test "should require name" do
    staff = Staff.new(employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)
    assert_not staff.valid?
    assert_includes staff.errors[:name], "can't be blank"
  end

  test "should require unique employee_id" do
    Staff.create!(name: "田中太郎", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)

    duplicate_staff = Staff.new(name: "佐藤花子", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)
    assert_not duplicate_staff.valid?
    assert_includes duplicate_staff.errors[:employee_id], "has already been taken"
  end

  test "should require positive salary" do
    staff = Staff.new(name: "田中太郎", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: -1000, store: @store)
    assert_not staff.valid?
    assert_includes staff.errors[:salary], "must be greater than 0"
  end

  test "should return correct status text" do
    staff = Staff.new(is_active: true)
    assert_equal "在籍中", staff.status_text

    staff.is_active = false
    assert_equal "退職済", staff.status_text
  end

  test "should format salary correctly" do
    staff = Staff.new(salary: 350000)
    assert_equal "¥350,000", staff.formatted_salary
  end

  test "should calculate years of service correctly" do
    staff = Staff.new(hire_date: 2.years.ago)
    assert_equal 2, staff.years_of_service

    staff.hire_date = 6.months.ago
    assert_equal 0, staff.years_of_service

    staff.hire_date = nil
    assert_equal 0, staff.years_of_service
  end

  test "should search by name" do
    staff1 = Staff.create!(name: "田中花子", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)
    staff2 = Staff.create!(name: "佐藤次郎", employee_id: "EMP002", position: "副店長", hire_date: 2.years.ago, salary: 350000, store: @store)

    results = Staff.search_by_name("田中")
    assert_includes results, staff1
    assert_not_includes results, staff2
  end

  test "should search by employee_id" do
    staff1 = Staff.create!(name: "田中花子", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)
    staff2 = Staff.create!(name: "佐藤次郎", employee_id: "MGR001", position: "副店長", hire_date: 2.years.ago, salary: 350000, store: @store)

    results = Staff.search_by_employee_id("EMP")
    assert_includes results, staff1
    assert_not_includes results, staff2
  end

  test "should search by position" do
    staff1 = Staff.create!(name: "田中花子", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)
    staff2 = Staff.create!(name: "佐藤次郎", employee_id: "EMP002", position: "副店長", hire_date: 2.years.ago, salary: 350000, store: @store)

    results = Staff.search_by_position("店員")
    assert_includes results, staff1
    assert_not_includes results, staff2
  end

  test "should filter by store" do
    other_store = Store.create!(name: "他の店舗", manager_name: "他の店長", address: "大阪", phone: "06-1234-5678")

    staff1 = Staff.create!(name: "田中花子", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store)
    staff2 = Staff.create!(name: "佐藤次郎", employee_id: "EMP002", position: "店員", hire_date: 1.year.ago, salary: 250000, store: other_store)

    results = Staff.by_store(@store.id)
    assert_includes results, staff1
    assert_not_includes results, staff2
  end

  test "should filter by status" do
    active_staff = Staff.create!(name: "田中花子", employee_id: "EMP001", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store, is_active: true)
    inactive_staff = Staff.create!(name: "佐藤次郎", employee_id: "EMP002", position: "店員", hire_date: 1.year.ago, salary: 250000, store: @store, is_active: false)

    assert_includes Staff.active, active_staff
    assert_not_includes Staff.active, inactive_staff

    assert_includes Staff.inactive, inactive_staff
    assert_not_includes Staff.inactive, active_staff
  end

  test "should provide contact info" do
    staff = Staff.new(phone: "090-1234-5678", email: "test@example.com")
    expected = "電話: 090-1234-5678 | メール: test@example.com"
    assert_equal expected, staff.contact_info

    staff.email = nil
    expected = "電話: 090-1234-5678"
    assert_equal expected, staff.contact_info
  end

  test "should provide full info" do
    staff = Staff.new(
      name: "田中花子",
      employee_id: "EMP001",
      position: "店員",
      store: @store
    )
    expected = "田中花子 (EMP001) - 店員 at テスト店舗"
    assert_equal expected, staff.full_info
  end
end
