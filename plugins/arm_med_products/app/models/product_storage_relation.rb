UpdateStorageFromError = Class.new(Exception)


class ProductStorageRelation < ActiveRecord::Base
  # Class used to represent the relations of an qa_issue

  belongs_to :product_storage_from, class_name: "ProductStorage"
  belongs_to :product_storage_to, class_name: "ProductStorage"
  belongs_to :product
  belongs_to :maintainer, class_name: "User"
  belongs_to :product_movement
  belongs_to :product_depreciation

  validates_presence_of :product_storage_from, :product, :maintainer, :count
  validates_presence_of  :product_storage_to, :unless => :deprecation?
  validate :from_and_to_are_different, :unless => :deprecation?
  validate :count_more_than_zero, :unless => :deprecation?
  # validates_uniqueness_of :product, :scope => :product_storage
  validate :cannot_move_from_not_existing_storage
  validate :cannot_move_from_empty_storage
  validate :cannot_move_more_then_exist_in_storage

  after_save :update_count_in_storage

  attr_protected :product_storage_from, :product_storage_to, :product, :maintainer, :product_movement, :product_depreciation

  # TODO: скопе movements и depreciations

  def initialize(attributes=nil, *args)
    super
    if new_record?
      if count.blank?
        self.count = 0
      end
    end
  end

  def deprecation?
    if is_depreciation.present?
      true
    else
      false
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
    if product_storage_from.empty_count?(product)
      errors.add :product_storage_from, :error_cannot_move_from_empty_storage
    end
  end

  def cannot_move_more_then_exist_in_storage
    if !product_storage_from.empty_count?(product) and product_storage_from.product_count(product) <= count
      errors.add :product_storage_from, :error_cannot_move_more_then_exist_in_storage
    end
  end

  # callbacks
  def update_count_in_storage
    update_storage_from if self.product_storage_from_id.present?
    update_storage_to if self.product_storage_to_id.present?
  end

  private
  def storage_from_id_params
    {product_id: product.id, storage_id: product_storage_from_id}
  end

  def storage_to_id_params
    {product_id: product.id, storage_id: product_storage_to_id}
  end

  def find_storage_from
    @storage_from = StorageProductCount.where(storage_from_id_params)
  end

  def find_storage_to
    @storage_to = StorageProductCount.where(storage_to_id_params)
  end

  def update_storage_from
    store = find_storage_from.first
    if store.nil?
      raise UpdateStorageFromError
    end
    store.count -= count
    store.save
  end

  def update_storage_to
    store = find_storage_to.first
    if store.nil?
      store = StorageProductCount.create(storage_to_id_params.merge(count: 0))
    end
    store.count += count
    store.save
  end
end
