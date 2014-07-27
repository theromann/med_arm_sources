module Select2SearchAdapters
  class SystemRoleSearchAdapter < SearchAdapter
    class << self
      def search_default(term, page, options)
        if options[:init].nil?
          roles = default_finder(SystemRole, term, {page: page})
          count = default_count(SystemRole, term, nil)
          {
              items: roles.map do |role|
                { text: role.name, id: role.id.to_s }
              end,
              total: count
          }
        else
          get_init_values(SystemRole, options[:item_ids])
        end
      end
    end
  end
end