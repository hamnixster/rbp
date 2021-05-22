require "minitest/autorun"
require "./lib/rofi"

class TestRofi < Minitest::Test
  def test_that_call_passes_prompt_option
    lines = ["a", "b"]

    stdin_mock = Minitest::Mock.new
    lines.each { |l| stdin_mock.expect :puts, true, [l] }
    stdin_mock.expect :close, true
    stdout_mock = Minitest::Mock.new
    stdout_mock.expect :read, "value from rofi   "

    open_info = lambda do |env, command, *opts, &block|
      assert opts.index("theme_name")
      assert opts.index("prompt_str")
      assert_nil opts.index("")
      assert_nil opts.index(nil)
      assert_equal opts[opts.index("theme_name") - 1], "-theme"
      assert_equal opts[opts.index("prompt_str") - 1], "-p"
      block.call(stdin_mock, stdout_mock)
    end

    Open3.stub :popen2, open_info do
      assert_equal Rofi.new.call("prompt_str", "theme_name", lines), "value from rofi"
    end

    stdin_mock.verify
    stdout_mock.verify
  end
end
