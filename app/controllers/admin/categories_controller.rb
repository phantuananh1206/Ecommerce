class Admin::CategoriesController < Admin::BaseController
  before_action :load_category, except: %i(index new create)

  def index
    @categories = Category.page(params[:page]).per(Settings.quantity_per_page)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = t('admin.category.create_success')
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t('admin.category.create_failed')
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:success] = t('admin.category.update_success')
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t('admin.category.update_failed')
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t('admin.category.delete_success')
    else
      flash[:danger] = t('admin.category.delete_failed')
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def load_category
    return if @category = Category.find_by(id: params[:id])

    flash[:danger] = t('admin.category.category_not_found')
    redirect_to admin_categories_path
  end
end
