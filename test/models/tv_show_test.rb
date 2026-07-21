require "test_helper"

class TvShowTest < ActiveSupport::TestCase
  include ContentTestCases

  self.content_factory = :tv_show

  test "destroying a tv_show destroys its seasons" do
    tv_show = create(:tv_show)
    season = create(:season, tv_show: tv_show)

    tv_show.destroy

    assert_raises(ActiveRecord::RecordNotFound) { season.reload }
  end
end
