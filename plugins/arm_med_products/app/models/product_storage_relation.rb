class ProductStorageRelation < ActiveRecord::Base
  # Class used to represent the relations of an qa_issue

  belongs_to :product_storage_from, class_name: "ProductStorage"
  belongs_to :product_storage_to, class_name: "ProductStorage"
  belongs_to :product
  belongs_to :maintainer, class_name: "User"
  belongs_to :product_movement



  validates_presence_of :product_storage_from, :product_storage_to, :product, :maintainer, :count
  # validates_uniqueness_of :product, :scope => :product_storage

  attr_protected :product_storage_from, :product_storage_to, :product, :maintainer, :product_movement

  def initialize(attributes=nil, *args)
    super
    if new_record?
      if count.blank?
        self.count = 0
      end
    end
  end

end
