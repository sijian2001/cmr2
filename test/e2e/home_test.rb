# frozen_string_literal: true

require_relative "e2e_test_helper"

# E2E test for home page
class HomeE2ETest < ActiveSupport::TestCase
  include E2ETestHelper

  def setup
    setup_playwright
  end

  def teardown
    teardown_playwright
  end

  test "should display home page" do
    visit "/"

    # ページが正常に読み込まれることを確認
    assert @page.title.present?, "Page should have a title"

    # ステータスコードが200であることを確認
    response = @page.goto("#{BASE_URL}/")
    assert response.ok?, "Home page should be accessible"
  end

  test "health check endpoint should return 200" do
    response = @page.goto("#{BASE_URL}/up")
    assert response.ok?, "Health check should return 200"
    assert has_text?("ok"), "Health check should display 'ok'"
  end
end
