require "test_helper"

class ListContentFetcherTest < ActiveSupport::TestCase
  test "raises RecordNotFound for a non-existent list" do
    assert_raises(ActiveRecord::RecordNotFound) do
      ListContentFetcher.call(list_id: -1)
    end
  end

  test "returns list_items ordered by position" do
    list = create(:list)
    third = create(:list_item, list: list, position: 3, content: create(:movie))
    first = create(:list_item, list: list, position: 1, content: create(:movie))
    second = create(:list_item, list: list, position: 2, content: create(:movie))

    result = ListContentFetcher.call(list_id: list.id)

    assert_equal [ first, second, third ], result.list_items.to_a
  end

  test "filters by content_type while preserving order" do
    list = create(:list)
    movie_item = create(:list_item, list: list, position: 1, content: create(:movie))
    create(:list_item, list: list, position: 2, content: create(:tv_show))
    another_movie_item = create(:list_item, list: list, position: 3, content: create(:movie))

    result = ListContentFetcher.call(list_id: list.id, content_type: "movie")

    assert_equal [ movie_item, another_movie_item ], result.list_items.to_a
  end

  test "raises InvalidContentTypeError for an unknown content_type" do
    list = create(:list)

    assert_raises(ListContentFetcher::InvalidContentTypeError) do
      ListContentFetcher.call(list_id: list.id, content_type: "user")
    end
  end

  test "paginates results" do
    list = create(:list)
    3.times { |n| create(:list_item, list: list, position: n + 1, content: create(:movie)) }

    result = ListContentFetcher.call(list_id: list.id, page: 2, per_page: 2)

    assert_equal 1, result.list_items.size
    assert_equal 3, result.total_count
    assert_equal 2, result.total_pages
  end

  test "returns an empty list for an out-of-range page" do
    list = create(:list)
    create(:list_item, list: list, position: 1, content: create(:movie))

    result = ListContentFetcher.call(list_id: list.id, page: 99)

    assert_empty result.list_items
  end

  test "defaults page and per_page when missing or invalid" do
    list = create(:list)

    result = ListContentFetcher.call(list_id: list.id, page: "not-a-number", per_page: -5)

    assert_equal ListContentFetcher::DEFAULT_PAGE, result.page
    assert_equal ListContentFetcher::DEFAULT_PER_PAGE, result.per_page
  end

  test "caps per_page at the configured maximum" do
    list = create(:list)

    result = ListContentFetcher.call(list_id: list.id, per_page: 1000)

    assert_equal ListContentFetcher::MAX_PER_PAGE, result.per_page
  end
end
