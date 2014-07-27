FactoryGirl.define do
  factory :project do
    name 'eCookbook'
    description 'Recipes management application'
    homepage 'http://ecookbook.somenet.foo/'
    is_public true
    identifier 'ecookbook-test'
  end
end
