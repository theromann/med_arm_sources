class ProductStorage < ActiveRecord::Base
  unloadable
  include Redmine::SubclassFactory

  belongs_to :type, class_name: "ProductStoragesType"
  private
  # Returns the Subclasses of DocKitSource.  Each Subclass needs to be
  # required in development mode.
  # Note: subclasses is protected in ActiveRecord
  def self.get_subclasses
    subclasses
  end
end
