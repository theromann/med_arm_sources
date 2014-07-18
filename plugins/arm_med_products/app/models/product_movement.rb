class ProductMovement < ActiveRecord::Base
  unloadable
  has_many :product_storage_relations
  accepts_nested_attributes_for :product_storage_relations, :reject_if => :all_blank, :allow_destroy => true
end
