class StorageProductCount < ActiveRecord::Base
  unloadable

  attr_accessor :product, :storage

  belongs_to :product, dependent: :destroy
  belongs_to :storage, class_name: "ProductStorage", dependent: :destroy

  # validates_presence_of :storage, :product, :count
  # validates_uniqueness_of :product, :scope => :storage


end
