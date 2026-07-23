class ListContentPresenter
  def initialize(result)
    @result = result
  end

  def as_json(*)
    {
      list: list_json,
      items: items_json,
      pagination: pagination_json
    }
  end

  private

  attr_reader :result

  def list_json
    { id: result.list.id, name: result.list.name }
  end

  def items_json
    result.list_items.map { |list_item| item_json(list_item) }
  end

  def item_json(list_item)
    {
      type: list_item.content_type,
      position: list_item.position,
      content: list_item.content.as_json(except: [ :created_at, :updated_at ])
    }
  end

  def pagination_json
    {
      page: result.page,
      per_page: result.per_page,
      total_pages: result.total_pages,
      total_count: result.total_count
    }
  end
end
