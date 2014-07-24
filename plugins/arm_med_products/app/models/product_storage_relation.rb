class ProductStorageRelation < ActiveRecord::Base
  # Class used to represent the relations of an qa_issue

  belongs_to :product_storage_from, class_name: "ProductStorage"
  belongs_to :product_storage_to, class_name: "ProductStorage"
  belongs_to :product
  belongs_to :maintainer, class_name: "User"
  belongs_to :product_movement

  validates_presence_of :product_storage_from, :product_storage_to, :product, :maintainer, :count
  validate :from_and_to_are_different
  validate :count_more_than_zero
  # validates_uniqueness_of :product, :scope => :product_storage
  validate :cannot_move_from_not_existing_storage
  validate :cannot_move_from_empty_storage
  validate :cannot_move_more_then_exist_in_storage


  attr_protected :product_storage_from, :product_storage_to, :product, :maintainer, :product_movement

  def initialize(attributes=nil, *args)
    super
    if new_record?
      if count.blank?
        self.count = 0
      end
    end
  end

  def from_and_to_are_different
    if product_storage_from == product_storage_to
      errors.add :product_storage_to, :error_has_different_name
    end
  end

  def count_more_than_zero
    if count == 0
      errors.add :count, :error_count_more_than_zero
    end
  end

  def cannot_move_from_not_existing_storage
    unless product.storages.include?(product_storage_from)
      errors.add :product_storage_from, :error_cannot_move_from_not_existing_storage
    end
  end

  def cannot_move_from_empty_storage
    if product_storage_from.empty?
      errors.add :product_storage_from, :error_cannot_move_from_empty_storage
    end
  end

  def cannot_move_more_then_exist_in_storage
    if !product_storage_from.empty? and product_storage_from.product_count <= count
      errors.add :product_storage_from, :error_cannot_move_more_then_exist_in_storage
    end
  end

end
