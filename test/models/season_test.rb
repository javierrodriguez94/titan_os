require "test_helper"

class SeasonTest < ActiveSupport::TestCase
  include ContentTestCases

  self.content_factory = :season

  test "invalid without a number" do
    season = build(:season, number: nil)

    assert_not season.valid?
    assert_includes season.errors[:number], "can't be blank"
  end

  test "invalid with a duplicate number within the same tv_show" do
    tv_show = create(:tv_show)
    create(:season, tv_show: tv_show, number: 1)
    season = build(:season, tv_show: tv_show, number: 1)

    assert_not season.valid?
    assert_includes season.errors[:number], "has already been taken"
  end

  test "valid with a duplicate number across different tv_shows" do
    create(:season, tv_show: create(:tv_show), number: 1)
    season = build(:season, tv_show: create(:tv_show), number: 1)

    assert season.valid?
  end

  test "invalid without a tv_show" do
    season = build(:season, tv_show: nil)

    assert_not season.valid?
    assert_includes season.errors[:tv_show], "must exist"
  end

  test "destroying a season destroys its episodes" do
    season = create(:season)
    episode = create(:episode, season: season)

    season.destroy

    assert_raises(ActiveRecord::RecordNotFound) { episode.reload }
  end
end
