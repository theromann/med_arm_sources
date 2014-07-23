class ProductCancellation < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  has_many :product_storage_relations
  belongs_to :author, class_name: "User"

  accepts_nested_attributes_for :product_storage_relations, :allow_destroy => true


  safe_attributes 'name',
                  'product_storage_relations_attributes'


end
