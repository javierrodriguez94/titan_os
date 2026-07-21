class List < ApplicationRecord
  has_many :list_items, -> { order(:position) }, dependent: :destroy

  validates :name, presence: true
end
