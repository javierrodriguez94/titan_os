class ListContentFetcher
  class InvalidContentTypeError < StandardError; end

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def self.call(...)
    new(...).call
  end

  def initialize(list_id:, content_type: nil, page: nil, per_page: nil)
    @list_id = list_id
    @content_type = content_type.presence
    @page = normalize_positive_integer(page, default: DEFAULT_PAGE)
    @per_page = normalize_positive_integer(per_page, default: DEFAULT_PER_PAGE, max: MAX_PER_PAGE)
  end

  attr_reader :page, :per_page

  def call
    list
    validate_content_type!
    self
  end

  def list
    @list ||= List.find(list_id)
  end

  def list_items
    @list_items ||= scoped_items.offset(offset).limit(per_page)
  end

  def total_count
    @total_count ||= scoped_items.count
  end

  def total_pages
    (total_count.to_f / per_page).ceil
  end

  private

  attr_reader :list_id, :content_type

  def validate_content_type!
    return nil if content_type.nil?

    raise_invalid_content_type unless normalized_content_type
  end

  def normalized_content_type
    ListItem::ALLOWED_CONTENT_TYPES.find { |type| type.underscore == content_type.to_s }
  end

  def raise_invalid_content_type
    allowed = ListItem::ALLOWED_CONTENT_TYPES.map(&:underscore).join(", ")
    raise InvalidContentTypeError, "content_type must be one of: #{allowed}"
  end

  def scoped_items
    items = list.list_items.includes(:content).order(:position)
    return items if content_type.nil?

    items.where(content_type: normalized_content_type)
  end

  def offset
    (page - 1) * per_page
  end

  def normalize_positive_integer(value, default:, max: nil)
    parsed = value.to_i
    return default unless parsed.positive?

    max ? [ parsed, max ].min : parsed
  end
end
