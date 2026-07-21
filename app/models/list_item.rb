class ListItem < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w[Movie TvShow Season Episode].freeze

  belongs_to :list
  belongs_to :content, polymorphic: true

  validates :position, presence: true, uniqueness: { scope: :list_id }
  validates :content_id, uniqueness: { scope: [ :list_id, :content_type ] }
  validates :content_type, inclusion: { in: ALLOWED_CONTENT_TYPES }
end
