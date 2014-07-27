FactoryGirl.define do
  factory :user do
    status 1
    language :ru
    # password = foo
    salt "3126f764c3c5ac61cbfc103f25f934cf"
    hashed_password "9e4dd7eeb172c12a0691a6d9d3a269f7e9fe671b"
    mail "rhill@somenet.foo"
    lastname "Hill"
    firstname "Robert"
    id 2
    mail_notification "all"
    login "rhill"
    type "User"
    department { FactoryGirl.create :department }
  end
end
