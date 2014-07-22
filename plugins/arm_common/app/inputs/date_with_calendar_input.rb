class DateWithCalendarInput < Formtastic::Inputs::StringInput
  def to_html
    input_wrapping do
      label_html + builder.text_field(method, input_html_options) + template.calendar_for(input_html_options[:id])
    end
  end

  def input_html_options
    {value: value}.merge(super).merge({size: 10, readonly: true})
  end

  def value
    val = object.send(method)
    return val.strftime('%Y-%m-%d') if val.is_a?(Time)
    return Time.now.strftime('%Y-%m-%d') if val.nil?
    val.to_s
  end
end