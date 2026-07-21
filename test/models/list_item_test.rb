require "test_helper"

class ListItemTest < ActiveSupport::TestCase
  test "valid with a list, a content and a position" do
    list_item = build(:list_item)

    assert list_item.valid?
  end

  test "invalid without a list" do
    list_item = build(:list_item, list: nil)

    assert_not list_item.valid?
    assert_includes list_item.errors[:list], "must exist"
  end

  test "invalid without a content" do
    list_item = build(:list_item, content: nil)

    assert_not list_item.valid?
    assert_includes list_item.errors[:content], "must exist"
  end

  test "invalid without a position" do
    list_item = build(:list_item, position: nil)

    assert_not list_item.valid?
    assert_includes list_item.errors[:position], "can't be blank"
  end

  test "invalid with a duplicate position within the same list" do
    list = create(:list)
    create(:list_item, list: list, position: 1)
    list_item = build(:list_item, list: list, position: 1)

    assert_not list_item.valid?
    assert_includes list_item.errors[:position], "has already been taken"
  end

  test "valid with a duplicate position across different lists" do
    create(:list_item, list: create(:list), position: 1)
    list_item = build(:list_item, list: create(:list), position: 1)

    assert list_item.valid?
  end

  test "invalid when the same content is added twice to the same list" do
    list = create(:list)
    movie = create(:movie)
    create(:list_item, list: list, content: movie, position: 1)
    list_item = build(:list_item, list: list, content: movie, position: 2)

    assert_not list_item.valid?
    assert_includes list_item.errors[:content_id], "has already been taken"
  end

  test "valid when the same content is added to different lists" do
    movie = create(:movie)
    create(:list_item, list: create(:list), content: movie, position: 1)
    list_item = build(:list_item, list: create(:list), content: movie, position: 1)

    assert list_item.valid?
  end

  test "invalid with a content_type outside the allowed list" do
    list_item = build(:list_item)
    list_item.content_type = "List"

    assert_not list_item.valid?
    assert_includes list_item.errors[:content_type], "is not included in the list"
  end
end
