module ArmCommon
  module ApplicationHelperPatch
    def self.included(base)
      unloadable
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :page_header_title, :extension

        def set_page_header_title_extension(html)
          @header_title_ext = html
        end

        def add_subtitle_on_header(subtitle)
          set_page_header_title_extension(" / #{subtitle}")
        end

        def rewrite_title(html)
          @rewrited_header_title = html
        end

        def link_to_product(product)
          link_to product.nomenclature, product_path(product)
        end

        def plugin_settings_for(plugin)
          if plugin.id == :vhod_pdm
            url_for(:controller => :pdm_settings, :action => :all)
          else
            url_for(:controller => :settings, :action => :plugin, :id => plugin)
          end
        end

        # перегрузка функции redmine позволяет передавать во flash массивы строк
        def render_flash_messages
          s = ''
          flash.each do |k, v|
            if v.is_a?(Array)
              s << content_tag('div', array_to_ul_list(v).html_safe, class: "flash #{k}", id: "flash_#{k}")
            else
              s << content_tag('div', v.html_safe, class: "flash #{k}", id: "flash_#{k}")
            end
          end
          s.html_safe
        end

        def array_to_ul_list(arr)
          list_messages = arr.collect{ |msg| content_tag(:li, msg) }
          content_tag(:ul, list_messages.join("\n").html_safe, class: 'messages-list')
        end

      end
    end

    module InstanceMethods


      def page_header_title_with_extension
        result = page_header_title_without_extension
        result = @rewrited_header_title if @rewrited_header_title.is_a? String
        result += @header_title_ext if @header_title_ext.is_a? String
        return result
      end
    end
  end
end