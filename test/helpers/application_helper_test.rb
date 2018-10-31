require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do
		assert_equal full_title, "H!"
		assert_equal full_title("Help"), "Help | H!"
	end
end