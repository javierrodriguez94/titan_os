FactoryBot.define do
  factory :season do
    sequence(:title) { |n| "Season #{n}" }
    sequence(:original_title) { |n| "Original Season #{n}" }
    year { 2000 }
    sequence(:number) { |n| n }
    tv_show
  end
end
