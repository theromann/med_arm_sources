class UnicodeValueCheckBoxesInput < Formtastic::Inputs::CheckBoxesInput
  def choice_input_dom_id(choice)
    [
        builder.custom_namespace,
        sanitized_object_name,
        builder.options[:index],
        association_primary_key || method,
        I18n.transliterate(choice).underscore.gsub(' ', '_').tr('^A-Za-z0-9_', '')
    ].compact.reject { |i| i.blank? }.join("_")
  end
end