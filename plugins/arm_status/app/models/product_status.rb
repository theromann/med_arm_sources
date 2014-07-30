# TODO удалить за ненадобностью
class ProductStatus < ArmStatus
  OptionName = :product_status

  has_many :products

  def option_name
    OptionName
  end

  def objects_count
    products.count
  end

  def transfer_relations(to)
    products.update_all(status_name: to.id)
  end

  def self.default
    d = super
    d = first if d.nil?
    d
  end
end