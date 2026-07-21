require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "valid with title, original_title and year" do
    movie = build(:movie)

    assert movie.valid?
  end

  test "invalid without a title" do
    movie = build(:movie, title: nil)

    assert_not movie.valid?
    assert_includes movie.errors[:title], "can't be blank"
  end

  test "invalid without an original_title" do
    movie = build(:movie, original_title: nil)

    assert_not movie.valid?
    assert_includes movie.errors[:original_title], "can't be blank"
  end

  test "invalid without a year" do
    movie = build(:movie, year: nil)

    assert_not movie.valid?
    assert_includes movie.errors[:year], "can't be blank"
  end

  test "strips surrounding whitespace from title and original_title" do
    movie = build(:movie, title: "  Inception  ", original_title: "  Inception  ")

    movie.valid?

    assert_equal "Inception", movie.title
    assert_equal "Inception", movie.original_title
  end
end
