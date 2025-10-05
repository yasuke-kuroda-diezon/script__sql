#!/bin/zsh

# load functions.
source ./script_sql/functions/log.sh

# ▼ config
local BACKUP_DIR="/Users/yasuke_kuroda/Documents/db_backup"
## ▼ headless.
local PROJECT_NAME="headless"
local STAGE="local"
local SEARCH_PATTERN="regolith_stg_user"
local REPLACEMENT_PATTERN="regolith_user"
## ▼ olta.
# local PROJECT_NAME="olta"
# local STAGE="local"
# local SEARCH_PATTERN="regolith_olta-stg_user"
# local REPLACEMENT_PATTERN="regolith_user"

function getLatestSqlFile() {
    local dir=$1
    ls -rtl $dir | grep -E "${PROJECT_NAME}-${STAGE}-.*\.sql" | tail -n 1 | awk '{print $9}'
}

function renameDbUser() {
    local targetPath=$1
    local command="sed -i '' 's/${SEARCH_PATTERN}/${REPLACEMENT_PATTERN}/g' $targetPath"
    logInfo "$command"
    eval $command
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

    # target path.
    local targetPath="${dir}/${sqlFile}"
    logInfo "target path: $targetPath"

    # execute command.
    renameDbUser $targetPath

    # log.
    if [ $? -eq 0 ]; then
        logSuccess "rename_db_user_for_local.sh successful."
    else
        logError "rename_db_user_for_local.sh failed."
    fi
}

main