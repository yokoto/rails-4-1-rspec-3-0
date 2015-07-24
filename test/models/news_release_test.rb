require "test_helper"

class NewsReleaseTest < ActiveSupport::TestCase
  should validate_presence_of :released_on
  should validate_presence_of :title
  should validate_presence_of :body

  test"returnstheformatteddateandtitleasastring"do
    news_release = NewsRelease.new(
      released_on: '2013-07-31',
      title: 'BigCo hires new CEO')
    assert_equal '2013-07-31: BigCo hires new CEO',
      news_release.title_with_date
  end
end
