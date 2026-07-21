class Episode < ApplicationRecord
  include Content

  belongs_to :season

  validates :number, presence: true, uniqueness: { scope: :season_id }
end
