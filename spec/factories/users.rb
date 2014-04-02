# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	email 'example@example.com'
    password '1234abcd'
    password_confirmation '1234abcd'
  end
end
