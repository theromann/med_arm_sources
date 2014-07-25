class StorageProductCount < ActiveRecord::Base
  unloadable

  attr_accessor :product, :storage

  belongs_to :product
  belongs_to :storage, class_name: "ProductStorage"

  # validates_presence_of :storage, :product, :count
  # validates_uniqueness_of :product, :scope => :storage


end
