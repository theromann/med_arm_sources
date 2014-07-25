class ProductStorage < ActiveRecord::Base
  unloadable
  include Redmine::SubclassFactory

  belongs_to :type, class_name: "ProductStoragesType"
  has_many :storage_product_counts, foreign_key: :storage_id, dependent: :destroy
  has_many :products, through: :storage_product_count




  def empty_count?(product) # for storage_from
    if product_count(product).nil?
      true
    else
      false
    end
  end

  def product_count(product)
    count = self.storage_product_counts.select {|s| s.product_id == product.id}.first.count
    count ||= 0
  end

  private
  # Returns the Subclasses of DocKitSource.  Each Subclass needs to be
  # required in development mode.
  # Note: subclasses is protected in ActiveRecord
  def self.get_subclasses
    subclasses
  end

end
