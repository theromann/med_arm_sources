class Product < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes
  belongs_to :location, class_name: 'ProductStorage'
  belongs_to :group, class_name: 'ProductsGroup'

  has_many :storage_product_counts, foreign_key: :product_id, dependent: :destroy
  has_many :storages, through: :storage_product_counts

  acts_as_customizable
  has_many :journals, :as => :journalized, :dependent => :destroy

  validates_presence_of :location, :name
  validates :name, :uniqueness => true

  validate :must_be_location_if_count_more_then_zero

  after_save :create_journal
  after_create :create_storage_product_count

  DEFAULT_SEARCH_FIELDS = %w( id name note product_item )

  SORTING_SEARCHING_FIELDS = %w( id name price status_name note unit product_item)

  SEARCH_FIELDS = [
      ['id', "`products`.id"],
      ['product_item', "`products`.product_item"],
      ['name', "`products`.name"],
      ['price', "`products`.price"],
      ['status', "`products`.status_name"],
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


  #TODO  сделано для обновления статусов продуктов
  # вообще похорошему надо как-то сделать по нормальному.
  def readonly?
    false
  end

  def notified_users
    []
  end

  def notified_watchers
    []
  end

  def init_journal(user, notes = "")
    @current_journal ||= Journal.new(:journalized => self, :user => user, :notes => notes)
    if new_record?
      @current_journal.notify = false
    else
      attrs = attributes_with_assocciations(attributes)
      @attributes_before_change = attrs
      @custom_values_before_change = {}
      self.custom_field_values.each {|c| @custom_values_before_change.store c.custom_field_id, c.value }
    end
    @current_journal
  end

  def attributes_with_assocciations(attrs)
    attrs = attrs.dup
    analytic_info = nil
    analytic_info = attrs.select{|k,v| k.include?('analytic')} if attrs['analytic_id'].present?
    analytic_info.delete('analytic_group') if analytic_info.present?
    attrs.select!{|k,v| !k.include?('analytic')}
    attrs.merge!({'analytic_info' => analytic_info})
    attrs
  end


# Returns the id of the last journal or nil
  def last_journal_id
    if new_record?
      nil
    else
      journals.maximum(:id)
    end
  end
# Returns a scope for journals that have an id greater than journal_id
  def journals_after(journal_id)
    scope = journals.reorder("#{Journal.table_name}.id ASC")
    if journal_id.present?
      scope = scope.where("#{Journal.table_name}.id > ?", journal_id.to_i)
    end
    scope
  end
# Returns the initial status of the issue
# Returns nil for a new issue
  def status_was
    if status_id_was && status_id_was.to_i > 0
      @status_was ||= IssueStatus.find_by_id(status_id_was)
    end
  end


  safe_attributes 'name',
                  'price',
                  'location_id',
                  'status_name',
                  'max_count',
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

  def status
    self.update_attribute(:status_name, ProductStatusCalculating.new(self).value) unless ProductStatusCalculating.new(self).value == self.status_name
    self.status_name
  end

  def default_storage
    StorageProductCount.where(product_id: self.id, storage_id: self.location_id).first
  end

  def create_storage_product_count
    StorageProductCount.create({product_id: self.id, storage_id: location_id, count: 0})
  end

  private
  def create_journal
    if @current_journal
      # attributes changes
      if @attributes_before_change
        #produtcs -  ["id", "name", "price", "location_id", "note", "unit", "status_name", "group_id", "product_item", "max_count"]
        (Product.column_names - %w(id )).each {|c|
          before = @attributes_before_change[c]
          after = send(c)
          next if before == after || (before.blank? && after.blank?)
          @current_journal.details << JournalDetail.new(:property => 'attr',
          :prop_key => c,
          :old_value => before,
          :value => after)
        }
      end
      if @custom_values_before_change
        # custom fields changes
        custom_field_values.each {|c|
          before = @custom_values_before_change[c.custom_field_id]
          after = c.value
          next if before == after || (before.blank? && after.blank?)
          if before.is_a?(Array) || after.is_a?(Array)
            before = [before] unless before.is_a?(Array)
            after = [after] unless after.is_a?(Array)
            # values removed
            (before - after).reject(&:blank?).each do |value|
              @current_journal.details << JournalDetail.new(:property => 'cf',
              :prop_key => c.custom_field_id,
              :old_value => value,
              :value => nil)
            end
            # values added
            (after - before).reject(&:blank?).each do |value|
              @current_journal.details << JournalDetail.new(:property => 'cf',
              :prop_key => c.custom_field_id,
              :old_value => nil,
              :value => value)
            end
          else
            @current_journal.details << JournalDetail.new(:property => 'cf',
            :prop_key => c.custom_field_id,
            :old_value => before,
            :value => after)
          end
        }
      end
      @current_journal.save
      # reset current journal
      init_journal @current_journal.user, @current_journal.notes
    end
  end

  def must_be_location_if_count_more_then_zero
    if count.present? and location.nil?
      errors.add :base, :error_must_be_location_if_count_more_then_zero
    end
  end



end

class ProductStatusCalculating

  def initialize(product)
    @product = product
  end

  def value
    ProductStatusPolice.new(persent).value
  end

  def persent
    if @product.max_count.nil? or (@product.max_count == 0)
      100
    else
      (@product.count.to_f / @product.max_count.to_f) * 100
    end
  end
end

class ProductStatusPolice
  include Redmine::I18n

  def initialize(persent)
      @persent = persent
    end

  def value
    if @persent > 50
      l("product_status_is_more")
    elsif @persent > 30
     l("product_status_is_medium")
    elsif @persent > 10
      l("product_status_is_low")
    else
      l("product_status_is_critical")
    end
  end

end