# frozen_string_literal: true

namespace :test do
  desc "Run Playwright E2E tests"
  task e2e: :environment do
    # テスト環境のセットアップ
    ENV["RAILS_ENV"] = "test"
    ENV["HEADLESS"] = "true" unless ENV.key?("HEADLESS")

    # E2Eテストを実行
    system("bin/rails test test/e2e/**/*_test.rb") || exit(1)
  end
end
