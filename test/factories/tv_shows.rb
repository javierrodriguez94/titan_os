FactoryBot.define do
  factory :tv_show do
    sequence(:title) { |n| "TV Show #{n}" }
    sequence(:original_title) { |n| "Original TV Show #{n}" }
    year { 2000 }
  end
end
