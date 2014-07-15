Query

class ProductQueryColumn < QueryColumn
  attr_accessor :centered
  def initialize(name, options={})
    self.centered = options[:centered]
    super
  end

  def css_classes
    classes = [name]
    if centered
      classes << 'centered'
    end
    classes.join(' ')
  end
end

class ProductQuery < Query
  unloadable

  self.queried_class = Product

  self.available_columns = [
      ProductQueryColumn.new(:id, sortable: "#{Product.table_name}.id", default_order: 'desc', name: 'id', caption: '#', frozen: true),
      ProductQueryColumn.new(:name, sortable: "#{Product.table_name}.name", default_order: 'desc'),
      ProductQueryColumn.new(:price, sortable: "#{Product.table_name}.price", default_order: 'desc'),
      ProductQueryColumn.new(:count, sortable: "#{Product.table_name}.count", default_order: 'desc'),
      # ProductQueryColumn.new(:location, sortable: "#{Location.table_name}.name", default_order: 'desc', groupable: true),
      ProductQueryColumn.new(:status, sortable: "#{ProductStatus.table_name}.name", default_order: 'desc', groupable: true),
      ProductQueryColumn.new(:group, sortable: "#{ProductsGroup.table_name}.name", default_order: 'desc', groupable: true),
      ProductQueryColumn.new(:note, sortable: "#{Product.table_name}.note", default_order: 'desc'),
      ProductQueryColumn.new(:unit, sortable: "#{Product.table_name}.unit", default_order: 'desc')
  ]

  def initialize_available_filters
    add_available_filter 'id', type: :integer, name: 'id'
    add_available_filter 'name', type: :list, values: Product.all.map(&:name).compact.map{|name| name}.uniq.sort
    add_available_filter 'price', type: :list, values: Product.all.map(&:price).compact.map{|price| price}.uniq.sort
    add_available_filter 'count', type: :list, values: Product.all.map(&:count).compact.map{|count| count}.uniq.sort
    # add_available_filter 'location_id', type: :list, values: Product.all.map(&:location).compact.map{|location| [location.to_s, location.id.to_s]}.uniq.sort
    add_available_filter 'status_id', type: :list, values: Product.all.map(&:status).compact.map{|status| [status.to_s, status.id.to_s]}.uniq.sort
    add_available_filter 'group_id', type: :list, values: Product.all.map(&:group).compact.map{|group| [group.to_s, group.id.to_s]}.uniq.sort
    add_available_filter 'note', type: :list, values: Product.all.map(&:note).compact.map{|note| note}.uniq.sort
    add_available_filter 'unit', type: :list, values: Product.all.map(&:note).compact.map{|unit| unit}.uniq.sort
    add_available_filter 'deadline', type: :date
  end

  def build_from_params(params)
    self.filters = {}
    super
  end

  # Returns the actions
  # Valid options are :order, :offset, :limit, :include, :conditions
  def products(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)
    conditions = [statement, options[:conditions]].select(&:present?).map do |condition|
      "(#{condition})"
    end.join(' AND ')
    Product.all(
        # include: ([:location, :status] + (options[:include] || [])).uniq,
        include: ([] + (options[:include] || [])).uniq,
        conditions: conditions,
        order: order_option,
        joins: joins_for_order_statement(order_option.join(',')),
        limit: options[:limit],
        offset: options[:offset]
    )
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  def products_count(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)
    conditions = [statement, options[:conditions]].select(&:present?).map do |condition|
      "(#{condition})"
    end.join(' AND ')
    Product.count(
        include: ([:location, :status] + (options[:include] || [])).uniq,
        conditions: conditions,
        order: order_option,
        joins: joins_for_order_statement(order_option.join(','))
    )
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  def default_columns_names
    @default_columns_names ||= begin
      Setting.plugin_arm_med_products[:product_list_default_columns].to_a.map(&:to_sym)
    end
  end

  # Returns the action count
  def product_count
    Product.count(joins: joins_for_order_statement(group_by_statement),
                  include: [:location, :status],
                  conditions: statement)
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  # Returns the action count by group or nil if query is not grouped
  def product_count_by_group(cond = '')
    r = nil
    if grouped?
      begin
        # Rails3 will raise an (unexpected) RecordNotFound if there's only a nil group value
        r = Product.count(joins: joins_for_order_statement(group_by_statement),
                          group: group_by_statement,
                          include: [:location, :status],
                          conditions: statement)
      rescue ActiveRecord::RecordNotFound
        r = {nil => product_count}
      end
      c = group_by_column
      if c.is_a?(QueryCustomFieldColumn)
        r = r.keys.inject({}) {|h, k| h[c.custom_field.cast_value(k)] = r[k]; h}
      end
    end
    r
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

end

