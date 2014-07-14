class AssignedEditorSelect2Input < Formtastic::Inputs::HiddenInput
  def to_html
    input_wrapping do
      label_html + builder.hidden_field(method, input_html_options) + template.button_tag(User.current.name,
                                                                                          type: :button,
                                                                                          id: :assign_assigned_editor,
                                                                                          data: {user_id: User.current.id})

    end
  end

  def input_html_options
    super.merge(value: value, class: 'select2-user')
  end

  def value
    val = object.send(method)
    return val.id.to_s if val.is_a?(User)
    val.to_s
  end
end