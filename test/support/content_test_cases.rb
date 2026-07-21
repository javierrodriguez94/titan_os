module ContentTestCases
  extend ActiveSupport::Concern

  class_methods do
    attr_accessor :content_factory
  end

  included do
    test "valid with title, original_title and year" do
      assert build(self.class.content_factory).valid?
    end

    test "invalid without a title" do
      record = build(self.class.content_factory, title: nil)

      assert_not record.valid?
      assert_includes record.errors[:title], "can't be blank"
    end

    test "invalid without an original_title" do
      record = build(self.class.content_factory, original_title: nil)

      assert_not record.valid?
      assert_includes record.errors[:original_title], "can't be blank"
    end

    test "invalid without a year" do
      record = build(self.class.content_factory, year: nil)

      assert_not record.valid?
      assert_includes record.errors[:year], "can't be blank"
    end

    test "strips surrounding whitespace from title and original_title" do
      record = build(self.class.content_factory, title: "  Padded  ", original_title: "  Padded  ")

      record.valid?

      assert_equal "Padded", record.title
      assert_equal "Padded", record.original_title
    end
  end
end
