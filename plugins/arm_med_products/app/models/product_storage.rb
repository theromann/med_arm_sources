class ProductStorage < ActiveRecord::Base
  unloadable
  include Redmine::SubclassFactory

  belongs_to :type, class_name: "ProductStoragesType"
  # has_many :product_storage_relations, foreign_key: :product_storage_from_id
  # has_many :products, through: :product_storage_relations
  has_many :storage_product_count, foreign_key: :storage_id
  has_many :products, through: :storage_product_count

  def empty_count? # for storage_from
    if product_count.nil?
      true
    else
      false
    end
  end

  def product_count
    return 0 if self.products.empty? or self.products.last.count.nil?
    self.products.last.count
  end



  private
  # Returns the Subclasses of DocKitSource.  Each Subclass needs to be
  # required in development mode.
  # Note: subclasses is protected in ActiveRecord
  def self.get_subclasses
    subclasses
  end




end
