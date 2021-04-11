class Admin::StoresController < Admin::BaseController
  before_action :load_store, except: %i(index new create)

  def index
    @stores = Store.page(params[:page]).per(Settings.quantity_per_page)
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      flash[:success] = t('admin.store.create_success')
      redirect_to admin_stores_path
    else
      flash.now[:danger] = t('admin.store.create_failed')
      render :new
    end
  end

  def edit; end

  def update
    if @store.update(store_params)
      flash[:success] = t('admin.store.update_success')
      redirect_to admin_stores_path
    else
      flash.now[:danger] = t('admin.store.update_failed')
      render :edit
    end
  end

  def destroy
    if @store.destroy
      flash[:success] = t('admin.store.delete_success')
    else
      flash[:danger] = t('admin.store.delete_failed')
    end
    redirect_to admin_stores_path
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :latitude, :longitude)
  end

  def load_store
    return if @store = Store.find_by(id: params[:id])

    flash[:danger] = t('admin.store.store_not_found')
    redirect_to admin_stores_path
  end
end
