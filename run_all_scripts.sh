#!/bin/zsh

# 実行順序は重要. 実行順序は変更しないこと.

# application
./script__sql/staging_application_export.sh
./script__sql/copy_application_stg_to_local.sh
./script__sql/rename_application_db_user_stg_to_local.sh
./script__sql/local_application_delete.sh
./script__sql/local_application_cat.sh # 空出力が期待値.
./script__sql/local_application_import.sh

## DB migrate.
docker exec -i regolith-admin-api ash -c "npx -y prisma migrate dev"
# docker exec -i olta-admin-api ash -c "npx -y prisma migrate dev"