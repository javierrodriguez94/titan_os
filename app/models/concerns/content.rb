module Content
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_title_attributes

    validates :title, presence: true
    validates :original_title, presence: true
    validates :year, presence: true
  end

  private

  def normalize_title_attributes
    self.title = title.strip if title.is_a?(String)
    self.original_title = original_title.strip if original_title.is_a?(String)
  end
end
