FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "Movie #{n}" }
    sequence(:original_title) { |n| "Original Movie #{n}" }
    year { 2000 }
  end
end
