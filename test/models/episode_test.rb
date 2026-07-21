require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  include ContentTestCases

  self.content_factory = :episode

  test "invalid without a number" do
    episode = build(:episode, number: nil)

    assert_not episode.valid?
    assert_includes episode.errors[:number], "can't be blank"
  end

  test "invalid with a duplicate number within the same season" do
    season = create(:season)
    create(:episode, season: season, number: 1)
    episode = build(:episode, season: season, number: 1)

    assert_not episode.valid?
    assert_includes episode.errors[:number], "has already been taken"
  end

  test "valid with a duplicate number across different seasons" do
    create(:episode, season: create(:season), number: 1)
    episode = build(:episode, season: create(:season), number: 1)

    assert episode.valid?
  end

  test "invalid without a season" do
    episode = build(:episode, season: nil)

    assert_not episode.valid?
    assert_includes episode.errors[:season], "must exist"
  end
end
