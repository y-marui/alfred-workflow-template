# alfred-workflow-template

> **これは日本語版（正本）です。**
> 英語版（参照）は [README.md](README.md) を参照してください。

> Alfred 5 Script Filter ワークフローのプロダクションレディなテンプレート。
> 10分で開発を開始できます。

[![CI](https://github.com/yourname/alfred-workflow-template/actions/workflows/ci.yml/badge.svg)](https://github.com/yourname/alfred-workflow-template/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 特徴

- **レイヤードアーキテクチャ** — Alfred 境界とビジネスロジックを分離
- **軽量 Alfred SDK** — レスポンスビルダー、ルーター、キャッシュ、設定、ロガー
- **コマンドベース UX** — `wf search`、`wf open`、`wf config`、`wf help`
- **フルテストスイート** — pytest で Alfred なしにテスト実行可能
- **CI/CD** — GitHub Actions でリント・テスト・ビルド・リリースを自動化
- **ベンダーパッケージング** — サードパーティ依存を `vendor/` にバンドル
- **AI 対応** — `AI_CONTEXT.md` + `CLAUDE.md` で AI アシスタントのコンテキストを管理

## インストール（エンドユーザー）

[リリースページ](https://github.com/yourname/alfred-workflow-template/releases) から
最新の `.alfredworkflow` をダウンロードし、ダブルクリックして Alfred にインストールしてください。

## クイックスタート（開発者）

```bash
git clone https://github.com/yourname/alfred-workflow-template
cd alfred-workflow-template

# 開発用依存関係をインストール
make install

# Alfred をローカルでシミュレート
make run Q="search foo"
make run Q="help"

# テストを実行
make test

# ワークフローパッケージをビルド
make build
# → dist/workflow-template-0.1.0.alfredworkflow
```

`dist/*.alfredworkflow` をダブルクリックして Alfred にインストールします。

## 使い方

```
wf <query>           検索（デフォルト）
wf search <query>    検索
wf open <name>       ショートカットを開く
wf config            設定の確認 / リセット
wf help              コマンド一覧を表示
```

詳細なドキュメント: [docs/usage.md](docs/usage.md)

## 開発

開発手順（コマンド追加・依存関係管理・ローカルテスト・リリース）は
[docs/development.md](docs/development.md) を参照してください。

## アーキテクチャ

詳細設計: [docs/architecture.md](docs/architecture.md)

```
Alfred → entry.py → safe_run → core → router → commands → services → clients
```

## このテンプレートのカスタマイズ手順

1. `workflow/info.plist` を編集:
   - `bundleid` を自分のバンドル ID に変更（例: `com.yourname.workflowname`）
   - キーワード（`wf`）を自分のトリガーキーワードに変更
   - `uuidgen` で生成した UUID に置き換え
2. `src/app/clients/api_client.py` を実際の API クライアントに置き換え
3. `pyproject.toml` のワークフロー名を更新
4. `src/app/commands/open_cmd.py` のショートカットを更新
5. `workflow/icon.png` を追加

## サポート

このテンプレートが役に立ったら、サポートしていただけると嬉しいです。

- [Buy Me a Coffee](https://www.buymeacoffee.com/y.marui)
- [GitHub Sponsors](https://github.com/sponsors/y-marui)

## ライセンス

MIT — [LICENSE](LICENSE) を参照
