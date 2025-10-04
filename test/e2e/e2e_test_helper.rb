# frozen_string_literal: true

require "test_helper"
require "playwright"

# E2E test helper for Playwright tests
module E2ETestHelper
  BASE_URL = ENV.fetch("BASE_URL", "http://localhost:3000")
  HEADLESS = ENV.fetch("HEADLESS", "true") == "true"
  SCREENSHOT_DIR = Rails.root.join("tmp", "screenshots")

  # Initialize Playwright and create browser context
  def setup_playwright
    # Playwrightの初期化を試みる
    begin
      @playwright = Playwright.create(playwright_cli_executable_path: "npx playwright")
    rescue StandardError => e
      # npxが利用できない場合は、デフォルトのパスを試す
      puts "Warning: Could not initialize Playwright with npx: #{e.message}"
      @playwright = Playwright.create
    end

    @browser = @playwright.chromium.launch(headless: HEADLESS)
    @context = @browser.new_context(base_url: BASE_URL)
    @page = @context.new_page

    # Ensure screenshot directory exists
    FileUtils.mkdir_p(SCREENSHOT_DIR)
  end

  # Clean up Playwright resources
  def teardown_playwright
    take_screenshot_on_failure if @page && failed?
    @page&.close
    @context&.close
    @browser&.close
    @playwright&.stop
  end

  # Navigate to a path
  def visit(path)
    @page.goto("#{BASE_URL}#{path}")
  end

  # Take screenshot on test failure
  def take_screenshot_on_failure
    screenshot_path = SCREENSHOT_DIR.join("#{name}_#{Time.now.to_i}.png")
    @page.screenshot(path: screenshot_path)
    puts "Screenshot saved: #{screenshot_path}"
  end

  # Check if the current test has failed
  def failed?
    !passed?
  end

  # Wait for element to be visible
  def wait_for(selector, timeout: 5000)
    @page.wait_for_selector(selector, timeout: timeout)
  end

  # Click element
  def click(selector)
    @page.click(selector)
  end

  # Fill input field
  def fill(selector, value)
    @page.fill(selector, value)
  end

  # Get page title
  def page_title
    @page.title
  end

  # Get page content
  def page_content
    @page.content
  end

  # Check if text exists on page
  def has_text?(text)
    @page.text_content("body").include?(text)
  end
end
