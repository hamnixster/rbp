require "minitest/autorun"
require "./lib/rbp"

class TestRbp < Minitest::Test
  def test_that_main_yields_section
    ::Rbp.main("test") do |section, _lines|
      assert_equal section, "test"
    end
  end

  def test_that_main_yields_lines_as_array
    ::Rbp.main("test") do |_section, lines|
      assert_equal lines.class, Array
    end
  end

  def test_that_main_returns_a_command_string
    assert ::Rbp.main("test") { |_section, _lines| "command_str" }
  end
end
