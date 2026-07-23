require "test_helper"

class Api::V1::ListsControllerTest < ActionDispatch::IntegrationTest
  test "returns the list and its items ordered by position" do
    list = create(:list, name: "Best of 2020")
    movie = create(:movie)
    tv_show = create(:tv_show)
    create(:list_item, list: list, position: 2, content: tv_show)
    create(:list_item, list: list, position: 1, content: movie)

    get api_v1_list_path(list)

    assert_response :success
    body = response.parsed_body

    assert_equal list.id, body.dig("list", "id")
    assert_equal "Best of 2020", body.dig("list", "name")
    assert_equal [ "Movie", "TvShow" ], body["items"].map { |item| item["type"] }
    assert_equal [ 1, 2 ], body["items"].map { |item| item["position"] }
    assert_equal movie.title, body["items"].first.dig("content", "title")
  end

  test "filters items by content_type while preserving order" do
    list = create(:list)
    create(:list_item, list: list, position: 1, content: create(:movie))
    create(:list_item, list: list, position: 2, content: create(:tv_show))
    create(:list_item, list: list, position: 3, content: create(:movie))

    get api_v1_list_path(list), params: { content_type: "movie" }

    assert_response :success
    body = response.parsed_body

    assert_equal [ "Movie", "Movie" ], body["items"].map { |item| item["type"] }
  end

  test "defaults pagination to page 1 and per_page 20" do
    list = create(:list)
    create(:list_item, list: list, position: 1, content: create(:movie))

    get api_v1_list_path(list)

    assert_response :success
    pagination = response.parsed_body["pagination"]

    assert_equal 1, pagination["page"]
    assert_equal 20, pagination["per_page"]
    assert_equal 1, pagination["total_count"]
  end

  test "paginates with custom page and per_page params" do
    list = create(:list)
    3.times { |n| create(:list_item, list: list, position: n + 1, content: create(:movie)) }

    get api_v1_list_path(list), params: { page: 2, per_page: 2 }

    assert_response :success
    body = response.parsed_body

    assert_equal 1, body["items"].size
    assert_equal 2, body.dig("pagination", "page")
    assert_equal 2, body.dig("pagination", "per_page")
    assert_equal 3, body.dig("pagination", "total_count")
  end

  test "returns an empty items array for an out-of-range page" do
    list = create(:list)
    create(:list_item, list: list, position: 1, content: create(:movie))

    get api_v1_list_path(list), params: { page: 99 }

    assert_response :success
    assert_empty response.parsed_body["items"]
  end

  test "returns an empty items array for a list without items" do
    list = create(:list)

    get api_v1_list_path(list)

    assert_response :success
    assert_empty response.parsed_body["items"]
  end

  test "returns 404 for a non-existent list" do
    get api_v1_list_path(-1)

    assert_response :not_found
    assert response.parsed_body["error"].present?
  end

  test "returns 422 for an invalid content_type" do
    list = create(:list)

    get api_v1_list_path(list), params: { content_type: "user" }

    assert_response :unprocessable_entity
    assert_match "content_type", response.parsed_body["error"]
  end
end
