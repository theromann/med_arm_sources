module ProductMovementsHelper
  def product_movement_heading(movement)
    "movement_header"
  end

  def authoring(created, author, options={})
    l(options[:label] || :label_created_time_by, author: link_to_user(author), age: format_time(created)).html_safe
  end

  def product_movement_fields_rows
    r = ProductMovementFieldsRows.new
    yield r
    r.to_html
  end

  def time
    @movement.time.present? ? @movement.time.strftime("%Y-%m-%d") : ''
  end

  def css_classes(movement)
    s = "product_movement"
    s
  end

  def header_classes(movement)
    s = "product_movement-header"
    s
  end

  def required_css_class(attr_name)
    ''
    # TODO:
    # @qa_action.required_attribute?(attr_name) ? 'required' : ''
  end

  class ProductMovementFieldsRows
    include ActionView::Helpers::TagHelper

    def initialize
      @left = []
      @right = []
    end

    def left(*args)
      args.any? ? @left << cells(*args) : @left
    end

    def right(*args)
      args.any? ? @right << cells(*args) : @right
    end

    def size
      @left.size > @right.size ? @left.size : @right.size
    end

    def to_html
      html = ''.html_safe
      blank = content_tag('th', '') + content_tag('td', '')
      size.times do |i|
        left = (@left[i].nil? or @left[i].empty?) ? blank : @left[i]
        right = (@right[i].nil? or @right[i].empty?) ? blank : @right[i]
        html << content_tag('tr', left + right)
      end
      html
    end

    def cells(label, text, options={})
      if label == '' and text == ''
        return ''
      else
        return content_tag('th', "#{label}:", options) + content_tag('td', text, options)
      end
    end
  end

  def calendar_with_time_for(field_id)
    include_calendar_headers_tags
    javascript_tag("$(function() { $('##{field_id}').datetimepicker(datepickerOptions); });")
  end
end
