class Product < ActiveRecord::Base
  unloadable
  # belongs_to :status, class_name: 'CountProductStatus'
  # belongs_to :location
  include Redmine::SafeAttributes
  DEFAULT_SEARCH_FIELDS = %w( id name note )

  SORTING_SEARCHING_FIELDS = %w( id name count price location status note unit )

  SEARCH_FIELDS = [
      ['id', "`qa_actions`.id"],
      ['name', "`products`.name"],
      ['count', "`products`.count"],
      ['price', "`products`.price"],
      # ['location', "`locations`.name"],
      # ['status', "`count_product_statuses`.name"],
      ['note', "`products`.note"],
      ['unit', "`products`.unit"]
  ]

  def self.search_conditions_from_query(query, filtered_fields)
    return "" if query.blank?
    conditions = []
    filtered_fields ||= DEFAULT_SEARCH_FIELDS
    query.split.each do |word|
      or_conditions = []
      SEARCH_FIELDS.each do |field|
        if filtered_fields.include?(field[0])
          search_word = word
          or_conditions << sanitize_sql_array(["#{field[1]} LIKE ?", "%#{search_word}%"])
        end
      end
      conditions << "(#{or_conditions.join(" OR ")})" unless or_conditions.empty?
    end
    conditions.join(" AND ")
  end

  def self.available_search_fields
    SORTING_SEARCHING_FIELDS
  end

  safe_attributes 'name',
                  'count',
                  'price',
                  'location_id',
                  'status_id',
                  'note',
                  'unit'


end
