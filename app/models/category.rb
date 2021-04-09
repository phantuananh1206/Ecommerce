class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }

  after_destroy :delete_parents

  scope :subcategories, -> { where.not(parent_id: nil) }
  scope :sort_name_categories_alphabetically, -> { order(name: :asc) }

  def delete_parents
    categories = Category.all
    categories.each do
      category = categories.find { |category| category.parent_id == self.id}
      next unless category

      category.update(parent_id: nil)
    end
  end
end
