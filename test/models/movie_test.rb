require "test_helper"

class MovieTest < ActiveSupport::TestCase
  include ContentTestCases

  self.content_factory = :movie
end
