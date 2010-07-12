require File.dirname(__FILE__) + '/test_helper'

class TestHTML < Test::Unit::TestCase
	def test_email
		assert_equal('&#99&#111&#110&#116&#114&#97&#99&#116&#102&#114&#111&#109&#98&#101&#108&#111&#119&#64&#103&#109&#97&#105&#108&#46&#99&#111&#109', Picombo::Html.email('contractfrombelow@gmail.com'))
	end

	def test_css
		assert_equal('<link type="text/css" href="http://localhost:3000/style.css" rel="stylesheet" />', Picombo::Html.style('style.css'))
		assert_equal('<link type="text/css" href="http://localhost:3000/style.css" rel="stylesheet" />
<link type="text/css" href="http://localhost:3000/style2.css" rel="stylesheet" />
', Picombo::Html.style(['style.css', 'style2.css']))
	end

	def test_js
		assert_equal('<script type="text/javascript" src="http://localhost:3000/behavior.js"></script>', Picombo::Html.script('behavior.js'))
		assert_equal('<script type="text/javascript" src="http://localhost:3000/behavior.js"></script>
<script type="text/javascript" src="http://localhost:3000/behavior2.js"></script>
', Picombo::Html.script(['behavior.js', 'behavior2.js']))
	end
end