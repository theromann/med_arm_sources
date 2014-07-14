class ArmStatus < ActiveRecord::Base
  include Redmine::SubclassFactory

  default_scope :order => "#{ArmStatus.table_name}.position ASC"
  before_destroy :check_integrity
  # has_many :workflows, :class_name => 'ArmWorkflowTransition', :foreign_key => "old_status_id"
  acts_as_list :scope => 'type = \'#{type}\''

  before_destroy :delete_workflow_rules
  after_save     :update_default

  attr_protected :type

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:type]
  validates_length_of :name, :maximum => 30

  scope :sorted, lambda { order("#{table_name}.position ASC") }
  scope :named, lambda {|arg| where("LOWER(#{table_name}.name) = LOWER(?)", arg.to_s.strip)}

  def update_default
    self.type.constantize.update_all({:is_default => false}, ['id <> ?', id]) if self.is_default?
  end

  # Returns the default status
  def self.default
    where(:is_default => true).first
  end

  # Returns an array of all statuses the given role can switch to
  # Uses association cache when called more than one time
  def new_statuses_allowed_to(roles, tracker, author=false, assignee=false)
    if roles && tracker
      role_ids = roles.collect(&:id)
      transitions = workflows.select do |w|
        role_ids.include?(w.role_id) &&
            w.tracker_id == tracker.id &&
            ((!w.author && !w.assignee) || (author && w.author) || (assignee && w.assignee))
      end
      transitions.map(&:new_status).compact.sort
    else
      []
    end
  end

  # Same thing as above but uses a database query
  # More efficient than the previous method if called just once
  def find_new_statuses_allowed_to(roles, tracker, author=false, assignee=false)
    if roles.present? && tracker
      conditions = "(author = :false AND assignee = :false)"
      conditions << " OR author = :true" if author
      conditions << " OR assignee = :true" if assignee

      workflows.
          includes(:new_status).
          where(["role_id IN (:role_ids) AND tracker_id = :tracker_id AND (#{conditions})",
                 {:role_ids => roles.collect(&:id), :tracker_id => tracker.id, :true => true, :false => false}
                ]).all.
          map(&:new_status).compact.sort
    else
      []
    end
  end

  def <=>(status)
    position <=> status.position
  end

  def in_use?
    self.objects_count != 0
  end

  def to_s; name end

  private

  def check_integrity
    #TODO
    #raise "Can't delete status" if Issue.where(:status_id => id).any?
  end

  # Overloaded on concrete classes
  def objects_count
    0
  end

  # Overloaded on concrete classes
  def option_name
    nil
  end

  # Returns the Subclasses of ArmStatus.  Each Subclass needs to be
  # required in development mode.
  #
  # Note: subclasses is protected in ActiveRecord
  def self.get_subclasses
    subclasses
  end

  # Deletes associated workflows
  def delete_workflow_rules
    # ArmWorkflowRule.delete_all(["old_status_id = :id OR new_status_id = :id", {:id => id}])
  end
end
