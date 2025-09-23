class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  def index
    @stores = Store.all
    @stores = @stores.search_by_name(params[:search_name])
    @stores = @stores.search_by_address(params[:search_address])
    @stores = @stores.search_by_manager(params[:search_manager])

    case params[:status_filter]
    when "active"
      @stores = @stores.active
    when "inactive"
      @stores = @stores.inactive
    end

    @stores = @stores.order(:name)
  end

  def show
  end

  def new
    @store = Store.new
  end

  def edit
  end

  def create
    @store = Store.new(store_params)

    if @store.save
      redirect_to @store, notice: '店舗が正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @store.update(store_params)
      redirect_to @store, notice: '店舗が正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @store.destroy
    redirect_to stores_url, notice: '店舗が正常に削除されました。'
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :address, :phone, :email, :manager_name, :opening_hours, :description, :is_active)
  end
end
