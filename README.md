
## 概要

ローカル・ステージング環境のPostgreSQL/MySQLデータベースのエクスポート・インポート・バックアップ・削除などを自動化するシェルスクリプト群です。

複数プロジェクト（headless/olta等）や複数DB（regolith/gateway等）に対応し、DBのバックアップ・リストア・ユーザー名置換・テーブル/型削除などの作業を安全に行えます。

## 必須条件.

brewで、psqlコマンドがインストールされていること

```
psql --version
psql (PostgreSQL) 16.10 (Homebrew)
```

## 使い方

### 初回のみ
1. **-docker/ 配下に、本コードを配置します. (初回のみ)
  ```
  cd olta-docker
  git clone git@github.com:yasuke-kuroda-diezon/script__sql.git
  ```

2. 本コードを、**-dockerリポジトリのGit管理の対象外とします. (初回のみ)
  ```
  echo "script__sql/" >> .git/info/exclude
  ```

3. スクリプトに実行権限を付与します (初回のみ)
  ```
  chmod +x ./script__sql/*.sh
  ```

4. configファイルに、接続情報を記載します.
  ```
  vim script__sql/config/config.sh

  ▼必要に応じて、以下の設定も行います.
  vim script__sql/config/headless-config.sh
  vim script__sql/config/olta-config.sh
  ```

### 日々の使い方
1. configファイルに、設定を記述します.

  (※設定の記述方法は、ファイル内に記載しています)
  ```
  vim script__sql/config/config.sh
  ```

2. スクリプト実行します

    2-1. 一括実行する場合.
    ```
    ./run_all_scripts.sh
    ```

    2-2. 個別に実行する場合.
    ```
    ./local_export_sql.sh
    ./local_cat_sql.sh
    ```


## スクリプト一覧

| コマンド | 概要 |
| --- | --- |
| ./staging_application_export.sh | ステージングDB（application）のエクスポート |
| ./copy_application_stg_to_local.sh | ステージングの最新applicationバックアップをローカル用にコピー |
| ./rename_application_db_user_stg_to_local.sh | application SQLファイル内のDBユーザー名をローカル用に置換 |
| ./local_application_delete.sh | ローカルDB（application）のテーブル・型を全削除 |
| ./local_application_cat.sh | ローカルDB（application）のテーブル・型一覧を表示 |
| ./local_application_export.sh | ローカルDB（application）のバックアップを保存 |
| ./local_application_import.sh | ローカルDB（application）にSQLファイルをインポート |
| ./staging_gateway_export.sh | ステージングDB（gateway）のエクスポート |
| ./copy_gateway_stg_to_local.sh | ステージングの最新gatewayバックアップをローカル用にコピー |
| ./rename_gateway_db_user_stg_to_local.sh | gateway SQLファイル内のDBユーザー名をローカル用に置換 |
| ./local_gateway_delete.sh | ローカルDB（gateway）のテーブル・型を全削除 |
| ./local_gateway_cat.sh | ローカルDB（gateway）のテーブル・型一覧を表示 |
| ./local_gateway_export.sh | ローカルDB（gateway）のバックアップを保存 |
| ./local_gateway_import.sh | ローカルDB（gateway）にSQLファイルをインポート |
| ./run_all_scripts.sh | 上記一連の処理をまとめて実行 |

## ディレクトリ構成

```
script__sql/
├── base/
│   └── main.sh
├── config/
│   ├── config.sh
│   ├── headless-config.sh
│   └── olta-config.sh
├── lib/
│   ├── log.sh
├── copy_application_stg_to_local.sh
├── copy_gateway_stg_to_local.sh
├── local_application_cat.sh
├── local_application_delete.sh
├── local_application_export.sh
├── local_application_import.sh
├── local_gateway_cat.sh
├── local_gateway_delete.sh
├── local_gateway_export.sh
├── local_gateway_import.sh
├── rename_application_db_user_stg_to_local.sh
├── rename_gateway_db_user_stg_to_local.sh
├── run_all_scripts.sh
├── staging_application_export.sh
├── staging_gateway_export.sh
└── README.md
```

## メモ

- バックアップディレクトリやSTGのDB接続情報は、Git管理できないので空欄にしてあります。
- config/ 配下の各設定ファイルで、プロジェクトやDBごとの接続情報を管理します。
- 社外から本スクリプトを実行してSTGのDBへ接続する際には、VPN接続が必要です。
- application/gateway それぞれで、エクスポート・インポート・削除・一覧表示などのスクリプトが分かれています。
- スクリプトの実行順序は run_all_scripts.sh を参照してください。