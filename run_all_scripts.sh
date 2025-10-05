#!/bin/zsh

# スクリプトのパスを設定
SCRIPTS_DIR="./script_sql"

# 各スクリプトを順番に実行
$SCRIPTS_DIR/export_sql.sh
$SCRIPTS_DIR/copy_staging_to_local.sh
$SCRIPTS_DIR/rename_db_user_for_local.sh
$SCRIPTS_DIR/delete_local_sql.sh
# $SCRIPTS_DIR/cat_local_sql.sh
$SCRIPTS_DIR/import_sql.sh
