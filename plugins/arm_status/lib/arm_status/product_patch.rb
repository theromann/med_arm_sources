module ArmStatusPlugin
  module ProductPatch
    extend ActiveSupport::Concern

    included do
      belongs_to :status, class_name: "ProductStatus"
    end

    #instance methods were here

    module ClassMethods
      #class methods were here
    end
  end
end
