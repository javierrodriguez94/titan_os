FactoryBot.define do
  factory :list_item do
    list
    association :content, factory: :movie
    sequence(:position) { |n| n }
  end
end
