class Season < ApplicationRecord
  include Content

  belongs_to :tv_show
  has_many :episodes, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :tv_show_id }
end
