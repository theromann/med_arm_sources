class ProductDepreciation< ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  attr_accessible :name, :product_storage_relations_attributes
  has_many :product_storage_relations
  accepts_nested_attributes_for :product_storage_relations, :allow_destroy => true

end
