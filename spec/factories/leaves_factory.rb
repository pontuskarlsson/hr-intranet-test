# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :leave do
    user
    starts_at DateTime.now + 10.days
    ends_at DateTime.now + 12.days
    event { |leave| FactoryGirl.create(:event, starts_at: leave.starts_at, ends_at: leave.ends_at, title: "#{ leave.user.full_name } - Annual Leave")  }
    comment 'Annual Leave'
    approved 1
  end
end
