# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## プロジェクト概要

顧客、製品、店舗、店員を管理するためのRuby on Rails 8ベースのCRM（顧客関係管理）システムです。現在、アプリケーションは基本的なRails構造を持つ初期状態で、CRM機能はまだ実装されていません。

## 開発コマンド

### サーバー・開発
- `bin/dev` - 開発サーバーを起動（Railsサーバー）
- `bin/rails server` - サーバーを起動する別の方法
- `bin/rails console` - デバッグ・テスト用のRailsコンソールを開く

### テスト・品質管理
- `bin/rails test` - テストスイートを実行
- `bin/rubocop` - Rubyのリンティング・スタイルチェックを実行
- `bin/brakeman` - セキュリティ脆弱性スキャンを実行

### データベース
- `bin/rails db:create` - データベースを作成
- `bin/rails db:migrate` - データベースマイグレーションを実行
- `bin/rails db:seed` - シードデータを読み込み
- `bin/rails db:reset` - データベースを削除、作成、マイグレーション、シードを実行

### コード生成
- `bin/rails generate` - モデル、コントローラーなどのRailsジェネレーターにアクセス

## アーキテクチャ・構造

### データベース設定
- **開発環境**: `storage/development.sqlite3`に保存されるSQLite3データベース
- **テスト環境**: `storage/test.sqlite3`に保存されるSQLite3データベース
- **本番環境**: primary、cache、queue、cable用の複数のSQLite3データベース

注意：README.mdではMySQL設定について記載されていますが、実際のdatabase.ymlではSQLite3を使用しています。

### アプリケーション構造
- **モジュール名**: `CrmRuby`
- **Railsバージョン**: 8.0
- **予定されている主要機能**（README記載）:
  - ユーザー認証とセッション管理
  - 顧客管理（CRUD操作）
  - 製品管理（CRUD操作）
  - 店舗管理（CRUD操作）
  - 店員管理（CRUD操作）

### 現在の状態
- デフォルト構造を持つ基本的なRails 8アプリケーション
- CRM機能のモデル、コントローラー、ビューはまだ実装されていない
- ApplicationControllerとApplicationRecordのみ存在
- ルートファイルにはデフォルトのヘルスチェックルートのみ
- モダンブラウザサポートが有効（`allow_browser versions: :modern`）

### 主要な依存関係
- **Rails**: 8.0.3
- **データベース**: sqlite3
- **サーバー**: Puma
- **フロントエンド**: Hotwire (Turbo + Stimulus), Importmap
- **キャッシュ**: solid_cache, solid_queue, solid_cable
- **デプロイ**: Kamal (Dockerベース)
- **コード品質**: rubocop-rails-omakase, brakeman

### 開発ポート
アプリケーションはデフォルトのRailsポート（3000）で動作するよう設定されています。