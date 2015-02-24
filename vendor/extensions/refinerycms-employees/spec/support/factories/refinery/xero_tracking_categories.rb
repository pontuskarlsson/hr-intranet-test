
FactoryGirl.define do
  factory :xero_tracking_category, :class => Refinery::Employees::XeroTrackingCategory do
    sequence(:guid) { |n| "00000000-0000-0000-0001-#{ n.to_s.rjust(12, '0') }" }
    sequence(:name) { |n| "Category ##{n}" }
    status Refinery::Employees::XeroTrackingCategory::STATUS_ACTIVE
    sequence(:options) { |n|
      [
          { guid: "0-#{ (Random.rand * 10000000).to_i }-#{ n.to_s.rjust(12, '0') }", name: "Option #1-#{n}" },
          { guid: "1-#{ (Random.rand * 10000000).to_i }-#{ n.to_s.rjust(12, '0') }", name: "Option #2-#{n}" }
      ]
    }
  end
end

