# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    group        'user'
    umbcusername 'student1'
  end

  factory :admin, :class => User do
    group        'admin'
    umbcusername 'staff5'
  end
end