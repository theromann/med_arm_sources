class ProductsSelect2Input < Formtastic::Inputs::HiddenInput
  def to_html
    input_wrapping do
      label_html + builder.hidden_field(method, input_html_options)
    end
  end

  def input_html_options
    {value: value, class: 'select2-multi'}.merge(super)
  end

  def value
    val = object.send(method)
    return val.map(&:id).join(',') if val.is_a?(Array)
    val.to_s
  end
end