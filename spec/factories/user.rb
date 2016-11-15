FactoryGirl.define do
  factory :user do
    email "user01@gmail.com"
    password "123456"
    api_key "qwerty"
    cards { [] }
  end
end
