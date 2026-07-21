FactoryBot.define do
  factory :episode do
    sequence(:title) { |n| "Episode #{n}" }
    sequence(:original_title) { |n| "Original Episode #{n}" }
    year { 2000 }
    sequence(:number) { |n| n }
    season
  end
end
