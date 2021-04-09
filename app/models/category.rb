class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error
  has_many :children, class_name: :Category, foreign_key: :parent_id
  belongs_to :parent, class_name: :Category, optional: true

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }
  validate :parent_id_valid

  after_destroy :update_child_categories

  scope :subcategories, -> { where.not(parent_id: nil) }
  scope :sort_name_categories_alphabetically, -> { order(name: :asc) }
  scope :parent_categories_valid, ->(id) { where.not(id: id).where.not(parent_id: id) }
  scope :child_category, ->(id) { where(parent_id: id)}

  def update_child_categories
    Category.child_category(id).update_all(parent_id: nil)
  end

  def parent_id_valid
    return if Category.find_by(id: parent_id) || parent_id == nil

    errors.add(:parent_id, I18n.t('admin.category.parent_id_not_found'))
  end
end
