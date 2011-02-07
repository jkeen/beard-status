require 'application'
require "rack/test"
require "test/unit"
require "webrat"

Webrat.configure do |config|
  config.mode = :rack
end

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def app
    Sinatra::Application.new
  end

  def test_index_page
    visit "/"
    last_response.should be_ok
    # last_response.should have_selector('dl.faces')
    # last_response.should have_selector('dl.beards')
  end
end
