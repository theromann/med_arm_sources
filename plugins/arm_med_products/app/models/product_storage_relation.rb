class ProductStorageRelation < ActiveRecord::Base
  # Class used to represent the relations of an qa_issue

  belongs_to :product_storage_from, class_name: "ProductStorageRelation"
  belongs_to :product_storage_to, class_name: "ProductStorageRelation"
  belongs_to :product
  belongs_to :maintainer, class_name: "User"
  belongs_to :product_movement

  validates_presence_of :product_storage, :product, :count
  validates_uniqueness_of :product, :scope => :product_storage

  attr_protected :product, :product_storage

  def initialize(attributes=nil, *args)
    super
    if new_record?
      if count.blank?
        self.count = 0
      end
    end
  end

end
