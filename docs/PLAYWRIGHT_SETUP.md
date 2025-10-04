# Playwright E2E Testing Setup Guide

## Overview
This document describes how to set up and run Playwright E2E tests for the CRM Ruby application.

## Prerequisites

### Required Software
- Ruby 3.4+
- Node.js 18+ (for Playwright)
- MySQL 8.0+ (or appropriate database permissions)
- Chromium browser (installed via Playwright)

## Installation

### 1. Install Ruby Dependencies
```bash
bundle install
```

### 2. Install Node.js Dependencies
```bash
npm install
```

### 3. Install Playwright Browsers
```bash
bundle exec playwright install chromium
```

### 4. Database Setup
Make sure your MySQL user has appropriate permissions:

```sql
-- Create test database
CREATE DATABASE IF NOT EXISTS crm2_test;

-- Grant permissions to user
GRANT ALL PRIVILEGES ON crm2_test.* TO 'crm2user'@'localhost';
FLUSH PRIVILEGES;
```

Then run migrations:
```bash
RAILS_ENV=test bin/rails db:create
RAILS_ENV=test bin/rails db:migrate
```

## Running Tests

### Run All E2E Tests
```bash
bin/rails test:e2e
```

### Run Tests in Non-Headless Mode (for debugging)
```bash
HEADLESS=false bin/rails test:e2e
```

### Run Specific Test File
```bash
bin/rails test test/e2e/customers_test.rb
```

### Run with Server in Separate Terminal
```bash
# Terminal 1: Start Rails server
RAILS_ENV=test bin/rails server -p 3000

# Terminal 2: Run tests
BASE_URL=http://localhost:3000 bin/rails test:e2e
```

## Configuration

### Environment Variables
- `BASE_URL`: Base URL for the application (default: `http://localhost:3000`)
- `HEADLESS`: Run browser in headless mode (default: `true`)
- `RAILS_ENV`: Rails environment (should be `test` for E2E tests)

### Playwright Configuration
Configuration is stored in `playwright.config.yml`:
- Browser: Chromium
- Timeout: 30 seconds per test
- Screenshots: Enabled on failure
- Screenshot location: `tmp/screenshots/`

## Test Structure

```
test/
  e2e/
    e2e_test_helper.rb    # Helper methods for E2E tests
    home_test.rb          # Home page tests
    customers_test.rb     # Customer CRUD tests
```

## Writing Tests

### Example Test
```ruby
require_relative "e2e_test_helper"

class MyE2ETest < ActiveSupport::TestCase
  include E2ETestHelper

  def setup
    setup_playwright
  end

  def teardown
    teardown_playwright
  end

  test "should do something" do
    visit "/path"
    fill 'input[name="field"]', "value"
    click 'button[type="submit"]'
    assert has_text?("Expected text")
  end
end
```

### Available Helper Methods
- `visit(path)`: Navigate to a path
- `fill(selector, value)`: Fill an input field
- `click(selector)`: Click an element
- `has_text?(text)`: Check if text exists on page
- `wait_for(selector)`: Wait for element to be visible
- `page_title`: Get current page title
- `page_content`: Get page HTML content

## Troubleshooting

### Error: "Playwright not found"
Make sure you have installed Playwright:
```bash
bundle exec playwright install chromium
```

### Error: "Connection refused"
Make sure the Rails server is running on port 3000:
```bash
RAILS_ENV=test bin/rails server -p 3000
```

### Error: "Database permission denied"
Check your MySQL user permissions and database configuration in `config/database.yml`.

### Screenshots Not Generated
Screenshots are automatically saved to `tmp/screenshots/` on test failure. Make sure this directory is writable.

## CI/CD Integration

E2E tests run automatically on GitHub Actions when:
- Pushing to `develop` or `main` branches
- Creating pull requests to `develop` or `main` branches

See `.github/workflows/playwright.yml` for CI configuration.

## Additional Resources

- [Playwright Ruby Client Documentation](https://github.com/YusukeIwaki/playwright-ruby-client)
- [Playwright Official Documentation](https://playwright.dev/)
- [Rails Testing Guide](https://guides.rubyonrails.org/testing.html)
