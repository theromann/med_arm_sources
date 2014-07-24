class ProductStorage < ActiveRecord::Base
  unloadable
  include Redmine::SubclassFactory

  belongs_to :type, class_name: "ProductStoragesType"
  has_many :product_storage_relations, foreign_key: :product_storage_from_id
  has_many :products, through: :product_storage_relations

  def empty? # for storage_from
    if product_count.nil?
      true
    else
      false
    end
  end

  def product_count
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
