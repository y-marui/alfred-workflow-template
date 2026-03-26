# Architecture

## Overview

This workflow uses a layered architecture to keep Alfred-specific code isolated
from business logic, making it easy to test and extend.

```
Alfred
  │  keyword + query
  ▼
workflow/scripts/entry.py       ← Alfred boundary (UI layer)
  │
  ▼
src/alfred/safe_run.py          ← Exception safety wrapper
  │
  ▼
src/app/core.py                 ← Application orchestrator
  │
  ▼
src/alfred/router.py            ← Command dispatcher
  │
  ├─ search  → src/app/commands/search.py
  ├─ open    → src/app/commands/open_cmd.py
  ├─ config  → src/app/commands/config_cmd.py
  └─ help    → src/app/commands/help_cmd.py
                │
                ▼
            src/app/services/   ← Business logic + caching
                │
                ▼
            src/app/clients/    ← External API / IO
```

## Layers

### UI Layer (`workflow/`)

- `scripts/entry.py`: The only file Alfred executes directly.
  - Sets up `sys.path` (vendor + src)
  - Calls `safe_run(main)`
  - No business logic here

### Alfred SDK (`src/alfred/`)

Thin helpers that abstract Alfred-specific behavior.
These are **not** application logic — they wrap Alfred's environment.

| Module | Purpose |
|---|---|
| `response.py` | Build and emit Script Filter JSON |
| `router.py` | Parse query → dispatch to command |
| `safe_run.py` | Catch exceptions → show error item |
| `cache.py` | TTL disk cache via `alfred_workflow_cache` |
| `config.py` | Persistent config via `alfred_workflow_data` |
| `logger.py` | File logger to `~/Library/Logs/Alfred/Workflow/` |

### Application Layer (`src/app/`)

Pure Python business logic — no Alfred dependency.
This layer can be tested without Alfred and run from the CLI.

| Directory | Purpose |
|---|---|
| `commands/` | One module per Alfred command. Each has `handle(args: str) -> None` |
| `services/` | Business logic coordinating between commands and clients |
| `clients/` | Thin HTTP/IO wrappers for external APIs |
| `core.py` | Wires router to commands — the dependency injection point |

## Query Parsing

Alfred sends the full query string to the script.
The router splits it into `<command> <args>`:

```
"search foo bar"  →  command="search",  args="foo bar"
"open repo"       →  command="open",    args="repo"
"config"          →  command="config",  args=""
"foo bar"         →  command="search",  args="foo bar" (default fallback)
```

## Dependency Flow

```
commands → services → clients → external APIs
         ↘
           alfred SDK (response, cache, config, logger)
```

Commands depend on services, not clients directly.
Services own caching logic.
Clients are stateless HTTP wrappers.

## Packaging

At build time (`make build`):

```
.build/               ← temporary build directory
├── info.plist        ← version synced from pyproject.toml
├── icon.png
├── scripts/
│   └── entry.py
├── src/              ← copied from repo src/
│   ├── alfred/
│   └── app/
└── vendor/           ← pip install -r requirements.txt -t vendor/
```

The entire `.build/` directory is zipped to `dist/<name>-<version>.alfredworkflow`.

## Alfred Configuration Builder (`userconfigurationconfig`)

Alfred 5 の Configuration Builder は `info.plist` の `userconfigurationconfig` キーで定義する。
ドキュメントがほぼないため、利用可能な型を以下にまとめる。

各エントリの共通フィールド:

| キー | 説明 |
|---|---|
| `type` | ウィジェット種別（下記参照） |
| `variable` | Alfred が環境変数として渡す変数名 |
| `label` | UI に表示されるラベル |
| `description` | ラベル下に表示される補足テキスト |
| `config` | 型ごとの設定（下記参照） |

### 型一覧

#### `textfield` — 1行テキスト入力

~~~xml
<dict>
    <key>type</key><string>textfield</string>
    <key>variable</key><string>MY_VAR</string>
    <key>label</key><string>API Key</string>
    <key>config</key>
    <dict>
        <key>default</key><string></string>
        <key>placeholder</key><string>Enter your key…</string>
        <key>required</key><false/>
        <key>trim</key><true/>
    </dict>
</dict>
~~~

#### `textarea` — 複数行テキスト入力

~~~xml
<dict>
    <key>type</key><string>textarea</string>
    <key>config</key>
    <dict>
        <key>default</key><string></string>
        <key>required</key><false/>
        <key>trim</key><true/>
        <key>verticalsize</key><integer>0</integer>
    </dict>
</dict>
~~~

#### `checkbox` — チェックボックス（値: `1` / `0`）

~~~xml
<dict>
    <key>type</key><string>checkbox</string>
    <key>variable</key><string>USE_UV</string>
    <key>label</key><string>Use uv</string>
    <key>config</key>
    <dict>
        <key>default</key><true/>
        <key>required</key><false/>
        <key>text</key><string>チェックボックス横に表示するテキスト</string>
    </dict>
</dict>
~~~

チェック時は `"1"`、未チェック時は `"0"` が変数にセットされる。

#### `popupbutton` — ドロップダウン選択

~~~xml
<dict>
    <key>type</key><string>popupbutton</string>
    <key>variable</key><string>MY_OPTION</string>
    <key>config</key>
    <dict>
        <key>default</key><string>option_a</string>
        <key>pairs</key>
        <array>
            <dict>
                <key>label</key><string>Option A</string>
                <key>value</key><string>option_a</string>
            </dict>
            <dict>
                <key>label</key><string>Option B</string>
                <key>value</key><string>option_b</string>
            </dict>
        </array>
    </dict>
</dict>
~~~

#### `filepicker` — ファイル/ディレクトリ選択

~~~xml
<dict>
    <key>type</key><string>filepicker</string>
    <key>variable</key><string>MY_PATH</string>
    <key>config</key>
    <dict>
        <key>default</key><string></string>
        <key>filtermode</key><integer>0</integer>  <!-- 0: files, 1: dirs, 2: both -->
        <key>placeholder</key><string></string>
        <key>required</key><false/>
    </dict>
</dict>
~~~

#### `slider` — スライダー（整数値）

~~~xml
<dict>
    <key>type</key><string>slider</string>
    <key>variable</key><string>MAX_RESULTS</string>
    <key>config</key>
    <dict>
        <key>minvalue</key><integer>0</integer>
        <key>maxvalue</key><integer>50</integer>
        <key>defaultvalue</key><integer>10</integer>
        <key>markercount</key><integer>5</integer>
        <key>showmarkers</key><true/>
        <key>onlystoponmarkers</key><false/>
    </dict>
</dict>
~~~

### `variables` / `prefs.plist` / `default` の関係

Alfred は設定値を三層で管理する:

| 場所 | 役割 |
|---|---|
| `userconfigurationconfig[].config.default` | Configuration Builder UI の初期表示のみ。変数への書き込みは行わない。 |
| `prefs.plist`（同ディレクトリ） | ユーザーが Configuration Builder で保存した値。Alfred が自動生成・更新する。 |
| `info.plist` の `variables` | スクリプトに常に渡したい固定の環境変数。Configuration Builder で管理する変数はここに入れない。 |

インストール直後は `prefs.plist` が存在しないため、変数は未セット。
スクリプト側で `${USE_UV:-0}` のようにデフォルト値を持たせることで対応する。
ユーザーが Configuration Builder で保存すると `prefs.plist` が生成・更新される。

~~~xml
<!-- prefs.plist: ユーザーが変更した値（Alfred が自動生成） -->
<dict>
    <key>USE_UV</key><false/>
</dict>
~~~

変数はスクリプト実行時に環境変数として渡されるため、シェルスクリプトでは `$USE_UV`、Python では `os.environ.get("USE_UV")` で参照できる。
