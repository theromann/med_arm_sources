FactoryGirl.define do
  factory :system_role do
    name 'test_system_role'
    position 10
    assignable true
    builtin true
    permissions [:test_system_permission]
    issues_visibility "default"
  end
end
