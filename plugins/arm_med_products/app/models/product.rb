class Product < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  belongs_to :status, class_name: 'CountProductStatus'
  belongs_to :location, class_name: 'ProductStorage'
  belongs_to :group, class_name: 'ProductsGroup'

  # has_many :product_storage_relations
  has_many :storages, class_name: 'ProductStorage'

  # accepts_nested_attributes_for :product_storage_relations, allow_destroy: true

  validates_presence_of :location, :name
  validate :must_be_location_if_count_more_then_zero

  after_save :create_storage_product_count

  DEFAULT_SEARCH_FIELDS = %w( id name note product_item )

  SORTING_SEARCHING_FIELDS = %w( id name count price status note unit product_item)

  SEARCH_FIELDS = [
      ['id', "`products`.id"],
      ['product_item', "`products`.product_item"],
      ['name', "`products`.name"],
      ['count', "`products`.count"],
      ['price', "`products`.price"],
      ['status', "`product_statuses`.name"],
      ['group', "`products_groups`.name"],
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
                  # 'status_id',
                  'note',
                  'unit',
                  'group_id',
                  'product_item',
                  'to_receipt'


  def to_receipt
  end

  def to_receipt=(count)
    self.count ||= 0
    self.count += count.to_i
  end

  def create_storage_product_count
    StorageProductCount.create({product_id: self.id, storage_id: location_id})
  end

  private

  def must_be_location_if_count_more_then_zero
    if count.present? and location.nil?
      errors.add :base, :error_must_be_location_if_count_more_then_zero
    end
  end
end
