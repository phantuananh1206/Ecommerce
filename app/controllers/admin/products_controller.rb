class Admin::ProductsController < Admin::BaseController
  before_action :load_product, except: %i(index new create)

  def index
    @products = Product.page(params[:page]).per(Settings.quantity_per_page)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = t('admin.product.create_success')
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      flash[:success] = t('admin.product.update_success')
      redirect_to admin_products_path
    else
      flash.now[:danger] = t('admin.product.update_failed')
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t('admin.product.delete_success')
    else
      flash[:danger] = t('admin.product.delete_failed')
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity,
                                    :description, :category_id, :brand_id)
  end

  def load_product
    return if @product = Product.find_by(id: params[:id])

    flash[:danger] = t('admin.product.product_not_found')
    redirect_to admin_products_path
  end
end
