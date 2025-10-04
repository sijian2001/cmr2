# Commit Message

## Title
feat: implement Playwright E2E testing framework

## Body

### 概要
PlaywrightによるE2Eテストフレームワークを実装しました。

### 主な変更内容

**テスト実装**
- E2Eテストヘルパーの作成 (test/e2e/e2e_test_helper.rb)
- ホームページテストの実装 (test/e2e/home_test.rb)
- 顧客管理CRUDテストの実装 (test/e2e/customers_test.rb)

**CI/CD統合**
- GitHub Actionsワークフローの追加 (.github/workflows/playwright.yml)
- MySQL serviceの設定
- 失敗時のスクリーンショット自動保存

**設定・タスク**
- Playwright設定ファイルの追加 (playwright.config.yml)
- Rakeタスクの追加 (lib/tasks/playwright.rake)
- Node.js依存関係の定義 (package.json)

**ドキュメント**
- セットアップガイドの作成 (docs/PLAYWRIGHT_SETUP.md)
- 実装サマリーの作成 (docs/IMPLEMENTATION_SUMMARY.md)
- READMEの更新 (E2Eテスト情報追加)

**その他の変更**
- CRMリソースルーティングの追加 (config/routes.rb)
- playwright-ruby-client gemの追加 (Gemfile)
- HomeControllerの不要なコード削除
- Devise initializerの一時的な無効化

### テストケース
- ページアクセステスト
- ヘルスチェックエンドポイントテスト
- 顧客の作成・更新・削除・検索テスト

### 使用方法
```bash
# E2Eテスト実行
bin/rails test:e2e

# ヘッドレスモード無効化(デバッグ用)
HEADLESS=false bin/rails test:e2e
```

Closes #10
