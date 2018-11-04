FactoryGirl.define do
  factory :user do
    password "123456"
    sequence(:email){|n| "correo_#{n}@factory.com"}
    sequence(:username){|n| "username#{n}" }
  end
end
