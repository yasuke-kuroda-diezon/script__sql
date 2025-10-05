#!/bin/zsh

# load functions.
source ./script_sql/functions/log.sh

### 必ずimport先はローカルとしたい. STGの情報は記載しないのが吉.
# ▼ config
local BACKUP_DIR="/Users/yasuke_kuroda/Documents/db_backup"
## ▼ headless.
local PROJECT_NAME="headless"
local STAGE="local"
local DB_TYPE="postgresql"
local DB_HOST="127.0.0.1"
local DB_PORT="5000"
local DB_USER="regolith_user"
local DB_PASS="Passw0rd"
local DB_NAME="regolith"
## ▼ olta.
# local PROJECT_NAME="olta"
# local STAGE="local"
# local DB_TYPE="postgresql"
# local DB_HOST="127.0.0.1"
# local DB_PORT="5010"
# local DB_USER="regolith_user"
# local DB_PASS="Passw0rd"
# local DB_NAME="regolith"

function getLatestSqlFile() {
    local dir=$1
    ls -rtl $dir | grep -E "${PROJECT_NAME}-${STAGE}-.*\.sql" | tail -n 1 | awk '{print $9}'
}

function importPostgresql() {
    local targetPath=$1
    local command="cat $targetPath | psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"
    logInfo "$command"

    # 環境変数PGPASSWORDをsetすることでパスワー入力を省略する.
    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function importMysql() {
    local targetPath=$1
    local cnfFile=$(mktemp)
    echo "[client]" > $cnfFile
    echo "user=$DB_USER" >> $cnfFile
    echo "password=$DB_PASS" >> $cnfFile
    echo "host=$DB_HOST" >> $cnfFile
    echo "port=$DB_PORT" >> $cnfFile
    local command="cat $targetPath | mysql --defaults-extra-file=$cnfFile $DB_NAME"
    logInfo "$(cat $cnfFile)"
    logInfo "$command"

    # mysqldump -p$PASSWORDではエラーになるので、--defaults-extra-fileで一時ファイルを読み込む形にする.
    eval $command
    rm -f $cnfFile
}

function main() {
    local dir="${BACKUP_DIR}/${PROJECT_NAME}/${STAGE}"
    logInfo "dir: $dir"

    # get latest import file.
    local sqlFile=$(getLatestSqlFile $dir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi 

    # import.
    local targetPath="${dir}/${sqlFile}"
    if [ "$DB_TYPE" = "postgresql" ]; then
        importPostgresql $targetPath
    elif [ "$DB_TYPE" = "mysql" ]; then
        importMysql $targetPath
    fi

    # log.
    if [ $? -eq 0 ]; then
        logSuccess "import_sql.sh successful: ${backupPath}"
    else
        logError "import_sql.sh failed: ${backupPath}"
    fi
}

main