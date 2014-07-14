module ProductsHelper

  class ProductFieldsRows
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


  def link_to_query_delete(query)
    link_to_delete ||= ""
    # if User.current.allowed_to?(:save_qa_queries, :system) && !query.is_public?
    # TODO: ProductQueryController
    link_to_delete = link_to("", {:controller => :product_queries,
                                    :action => :destroy,
                                    :id => query}, :method => :delete,
                               :class => "icon icon-del", :confirm => l(:confirm_delete_product_query))

    # end
    link_to_delete
  end

  def product_query_links(title, queries)
    # links to #index on qa_actions/show
    content_tag('h3', h(title)) +
        queries.collect {|query|
          css = 'query'
          css << ' selected' if query == @query
          link_to(h(query.name), products_path(:query_id => query), :class => css) + link_to_query_delete(query)
        }.join('<br />').html_safe
  end

  def sidebar_product_queries
    ProductQuery.where(is_public: false, type: "ProductQuery").all(:order => :name)
  end

  def public_sidebar_product_queries
    ProductQuery.where(:is_public => true).all(:order => :name)
  end

  def qa_action_heading(product)
    h("#{product.name} ##{product.id}" )
  end

  def product_fields_rows
    r = ProductFieldsRows.new
    yield r
    r.to_html
  end

  def css_classes(qa_action)
    s = "product"
    s
  end

  def header_classes(qa_issue)
    s = "product-header"
    s
  end

  def calendar_with_time_for(field_id)
    include_calendar_headers_tags
    javascript_tag("$(function() { $('##{field_id}').datetimepicker(datepickerOptions); });")
  end

  def repair_receipt_date(date)
    date.present? ? date.strftime('%Y-%m-%d') : ''
  end

  def available_search_fields_options
    selected_fields = session[:product_fields] || Product::DEFAULT_SEARCH_FIELDS
    options_for_select(Product.available_search_fields.map { |field| [l('search_fields.'+field), field] },
                       selected_fields)
  end
end
