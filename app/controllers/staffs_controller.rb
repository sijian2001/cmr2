class StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  def index
    @staffs = Staff.includes(:store).all
    @staffs = @staffs.search_by_name(params[:search_name])
    @staffs = @staffs.search_by_employee_id(params[:search_employee_id])
    @staffs = @staffs.search_by_position(params[:search_position])
    @staffs = @staffs.search_by_department(params[:search_department])
    @staffs = @staffs.by_store(params[:store_filter])

    case params[:status_filter]
    when "active"
      @staffs = @staffs.active
    when "inactive"
      @staffs = @staffs.inactive
    end

    @staffs = @staffs.order(:name)
    @stores = Store.all.order(:name)
  end

  def show
  end

  def new
    @staff = Staff.new
    @stores = Store.all.order(:name)
  end

  def edit
    @stores = Store.all.order(:name)
  end

  def create
    @staff = Staff.new(staff_params)

    if @staff.save
      redirect_to @staff, notice: '店員が正常に作成されました。'
    else
      @stores = Store.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @staff.update(staff_params)
      redirect_to @staff, notice: '店員が正常に更新されました。'
    else
      @stores = Store.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @staff.destroy
    redirect_to staffs_url, notice: '店員が正常に削除されました。'
  end

  private

  def set_staff
    @staff = Staff.find(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:name, :employee_id, :position, :department, :email, :phone, :hire_date, :salary, :store_id, :is_active)
  end
end
