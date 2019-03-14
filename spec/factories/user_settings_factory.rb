# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user_setting do
    user nil
    identifier "MyString"
    content ({})
  end
end
