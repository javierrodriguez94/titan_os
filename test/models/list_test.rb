require "test_helper"

class ListTest < ActiveSupport::TestCase
  test "valid with a name" do
    list = build(:list)

    assert list.valid?
  end

  test "invalid without a name" do
    list = build(:list, name: nil)

    assert_not list.valid?
    assert_includes list.errors[:name], "can't be blank"
  end

  test "returns list_items ordered by position" do
    list = create(:list)
    third = create(:list_item, list: list, position: 3)
    first = create(:list_item, list: list, position: 1)
    second = create(:list_item, list: list, position: 2)

    assert_equal [ first, second, third ], list.list_items.to_a
  end

  test "destroying a list destroys its list_items" do
    list = create(:list)
    list_item = create(:list_item, list: list)

    list.destroy

    assert_raises(ActiveRecord::RecordNotFound) { list_item.reload }
  end
end
