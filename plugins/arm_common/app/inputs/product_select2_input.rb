class ProductSelect2Input < ProductsSelect2Input
  def input_html_options
    {value: value}.merge(super)
  end

  def value
    val = object.send(method)
    return val.id.to_s if val.is_a?(Product)
    val.to_s
  end
end