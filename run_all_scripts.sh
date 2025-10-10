#!/bin/zsh

# 実行順序は重要. 実行順序は変更しないこと.

# application
./script__sql/staging_application_export.sh
./script__sql/copy_application_stg_to_local.sh
./script__sql/rename_application_db_user_stg_to_local.sh
./script__sql/local_application_delete.sh
./script__sql/local_application_cat.sh # 空出力が期待値.
./script__sql/local_application_import.sh

# ※以下のコメントアウトは外さないこと.
# ※以下のコメントアウトを外して本スクリプト実行したら、ローカルDB壊れます.

# api gatewayはSTGからローカルにコピー不要. 
# # gateway
# ./script__sql/staging_gateway_export.sh
# ./script__sql/copy_gateway_stg_to_local.sh
# ./script__sql/rename_gateway_db_user_stg_to_local.sh
# ./script__sql/local_gateway_delete.sh
# ./script__sql/local_gateway_cat.sh # 空出力が期待値.
# ./script__sql/local_gateway_import.sh
