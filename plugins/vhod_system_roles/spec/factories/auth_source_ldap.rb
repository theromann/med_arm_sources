FactoryGirl.define do
  factory :auth_source_ldap do
    name "ldap"
    host "example.com"
    port "3333"
    attr_login "accName"
  end
end