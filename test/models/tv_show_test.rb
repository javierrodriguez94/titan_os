require "test_helper"

class TvShowTest < ActiveSupport::TestCase
  include ContentTestCases

  self.content_factory = :tv_show
end
