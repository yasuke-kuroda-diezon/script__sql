#!/bin/zsh

# load functions.
source ./script_sql/functions/log.sh

# ▼ config
local BACKUP_DIR="/Users/yasuke_kuroda/Documents/db_backup"
## ▼ headless.
### staging.
local PROJECT_NAME="headless"
local STAGE="staging"
local DB_TYPE="postgresql"
local DB_HOST="regolith-stg-rds.ciyb2maowwrd.ap-northeast-1.rds.amazonaws.com"
local DB_PORT="5432"
local DB_USER="root"
local DB_PASS="xQ2kvGwJ"
local DB_NAME="regolith_stg"
### local.

## ▼ olta.
### staging.
# local PROJECT_NAME="olta"
# local STAGE="staging"
# local DB_TYPE="postgresql"
# local DB_HOST="olta-stg-rds.cl8ejsrfabtw.ap-northeast-1.rds.amazonaws.com"
# local DB_PORT="5432"
# local DB_USER="root"
# local DB_PASS="C6b2uU_v3"
# local DB_NAME="regolith_olta-stg"
# local PROJECT_NAME="olta"
### local.
# local STAGE="local"
# local DB_TYPE="postgresql"
# local DB_HOST="127.0.0.1"
# local DB_PORT="5010"
# local DB_USER="regolith_user"
# local DB_PASS="Passw0rd"
# local DB_NAME="regolith"

## ▼ UCOT. ▼エラーが出る. EC2にSSH接続経由してDB接続するためか、利用できないみたいだ.. oh..
#local PROJECT_NAME="ucot"
#local STAGE="local"
#local DB_TYPE="mysql"
#local DB_HOST="127.0.0.1"
#local DB_PORT="5160"
#local DB_USER="eccube_user"
#local DB_PASS="Passw0rd"
#local DB_NAME="eccube"

function exportPostgresql() {
    local exportPath=$1
    local command="pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME > $exportPath"
    logInfo "$command"

    # 環境変数PGPASSWORDをsetすることでパスワー入力を省略する.
    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function exportMysql() {
    local exportPath=$1
    local cnfFile=$(mktemp)
    echo "[client]" > $cnfFile
    echo "user=$DB_USER" >> $cnfFile
    echo "password=$DB_PASS" >> $cnfFile
    echo "host=$DB_HOST" >> $cnfFile
    echo "port=$DB_PORT" >> $cnfFile
    local command="mysqldump --defaults-extra-file=$cnfFile $DB_NAME --no-tablespaces > $exportPath"
    logInfo "$(cat $cnfFile)"
    logInfo "$command"

    # mysqldump -p$PASSWORDではエラーになるので、--defaults-extra-fileで一時ファイルを読み込む形にする.
    eval $command
    rm -f $cnfFile
}

function main() {
    local dir="${BACKUP_DIR}/${PROJECT_NAME}/${STAGE}"
    mkdir -p $dir

    # get export path.
    local exportPath="${dir}/${PROJECT_NAME}-${STAGE}-$(date +%Y-%m%d).sql"

    # export.
    if [ "$DB_TYPE" = "postgresql" ]; then
        exportPostgresql $exportPath
    elif [ "$DB_TYPE" = "mysql" ]; then
        exportMysql $exportPath
    fi

    # log.
    if [ $? -eq 0 ]; then
        logSuccess "export_sql.sh successful: ${exportPath}"
    else
        logError "export_sql.sh failed: ${exportPath}"
    fi
}

main