class TvShow < ApplicationRecord
  include Content

  has_many :seasons, dependent: :destroy
end
