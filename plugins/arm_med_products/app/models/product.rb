class Product < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  belongs_to :status, class_name: 'CountProductStatus'
  belongs_to :location, class_name: 'ProductStorage'
  belongs_to :group, class_name: 'ProductsGroup'

  has_many :storage_product_counts, foreign_key: :product_id, dependent: :destroy
  has_many :storages, through: :storage_product_counts

  validates_presence_of :location, :name
  validate :must_be_location_if_count_more_then_zero

  after_create :create_storage_product_count

  DEFAULT_SEARCH_FIELDS = %w( id name note product_item )

  SORTING_SEARCHING_FIELDS = %w( id name price status note unit product_item)

  SEARCH_FIELDS = [
      ['id', "`products`.id"],
      ['product_item', "`products`.product_item"],
      ['name', "`products`.name"],
      ['price', "`products`.price"],
      ['status', "`product_statuses`.name"],
      ['group', "`products_groups`.name"],
      ['location', "`locations`.name"],
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
                  'price',
                  'location_id',
                  # 'status_id',
                  'count',
                  'note',
                  'unit',
                  'group_id',
                  'product_item',
                  'to_receipt'


  def count
    sum_count = 0
    storage_product_counts.each {|sp| sum_count += sp.count }
    sum_count
  end

  def count=(c)
    locat = default_storage
    locat.count += c.to_i
    locat.save
  end


  # def to_receipt
  # end
  #
  # def to_receipt=(count)
  #   product_count = StorageProductCount.where({product_id: self.id, storage_id: location_id}).first
  #   product_count.count += count.to_i
  #   product_count.save
  # end

  def default_storage
    StorageProductCount.where(product_id: self.id, storage_id: self.location_id).first
  end

  def create_storage_product_count
    StorageProductCount.create({product_id: self.id, storage_id: location_id, count: 0})
  end

  private

  def must_be_location_if_count_more_then_zero
    if count.present? and location.nil?
      errors.add :base, :error_must_be_location_if_count_more_then_zero
    end
  end
end
