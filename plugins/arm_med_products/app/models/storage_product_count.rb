class StorageProductCount < ActiveRecord::Base
  unloadable

  attr_accessor :product, :storage

  belongs_to :product
  belongs_to :storage, class_name: "ProductStorage"

  after_save :update_journal
  # validates_presence_of :storage, :product, :count
  # validates_uniqueness_of :product, :scope => :storage

  private
  def update_journal
    # TODO: чтото на подобии такого надо сделать для моделей Relation и тп
    # unless product.created_at == product.updated_at
    #   new_journal = Product.find(product_id).init_journal(User.current)
    #   new_journal.details << JournalDetail.new(:property => 'product_storage', :prop_key => storage_id, :value => ProductStorage.find(storage_id).name)
    #   new_journal.save
    # end
  end

end
