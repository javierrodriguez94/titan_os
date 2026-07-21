FactoryBot.define do
  factory :list do
    sequence(:name) { |n| "List #{n}" }
  end
end
