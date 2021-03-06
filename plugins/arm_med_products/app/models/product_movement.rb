class ProductMovement < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes
  belongs_to :author, class_name: "User"

  has_many :product_storage_relations
  accepts_nested_attributes_for :product_storage_relations, :allow_destroy => true

  safe_attributes 'name',
                  'product_storage_relations_attributes'
end
