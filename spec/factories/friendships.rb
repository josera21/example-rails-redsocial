FactoryGirl.define do
  factory :friendship do
  	# Aprovechamos los users que creamos en factory para hacer test en friendships
    association :user, factory: :user
    association :friend, factory: :user
    status "MyString"
  end
end
