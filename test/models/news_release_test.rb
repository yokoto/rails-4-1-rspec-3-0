require "test_helper"

describe NewsRelease do
  should validate_presence_of :released_on
  should validate_presence_of :title
  should validate_presence_of :body

  it "returns the formatted date and title as a string" do
    news_release = NewsRelease.new(
      released_on: '2013-07-31',
      title: 'BigCo hires new CEO')
    news_release.title_with_date.must_equal \
      '2013-07-31: BigCo hires new CEO'
  end
end
