module ArmMedProducts
  module QueriesHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :column_header, :product
      end
    end

    module InstanceMethods
      def product_column_content(column, product)
        value = column.value(product)
        product_column_value(column, product, value)
      end

      def product_column_value(column, product, value)
        case value.class.name
        # when 'Product', 'ProductDse', 'ProductDseEskd', 'ProductEspd', 'ProductWoutEspd'
        #   link_to_product(value)
        when 'Fixnum'
          if column.name == :id
            link_to value, product_path(product)
          else
            value.to_s
          end
        when 'String'
          if column.name == :name
            link_to value, product_path(product)
          else
            value.to_s
          end
        when 'Time'
          value.strftime("%d.%m.%Y")
        else
          column_value(column, nil, value)
        end
      end

      def column_header_with_product(column)
        classes = [column.name.to_s]
        if column.sortable
          sort_header_tag(column.name.to_s,
                          caption: column.caption,
                          default_order: column.default_order,
                          class: classes.join(' '))
        else
          content_tag('th', h(column.caption), class: classes.join(' '))
        end
      end
    end
  end
end