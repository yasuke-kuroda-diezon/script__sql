#!/bin/zsh

# load functions.
source ./script_sql/functions/log.sh

# ▼ config
local BACKUP_DIR="/Users/yasuke_kuroda/Documents/db_backup"
## ▼ headless.
local PROJECT_NAME="headless"
local STAGE_FROM="staging"
local STAGE_TO="local"
## ▼ olta.
# local PROJECT_NAME="olta"
# local STAGE_FROM="staging"
# local STAGE_TO="local"

function getLatestSqlFile() {
    local dir=$1
    ls -rtl $dir | grep -E "${PROJECT_NAME}-${STAGE_FROM}-.*\.sql" | tail -n 1 | awk '{print $9}'
}

function main() {
    # copy from staging.
    local copyFromDir="${BACKUP_DIR}/${PROJECT_NAME}/${STAGE_FROM}"
    # logInfo "copy from dir : $copyFromDir"

    # get latest import file.
    local sqlFile=$(getLatestSqlFile $copyFromDir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi 
    local copyFromPath="${copyFromDir}/${sqlFile}"
    logInfo "copy from path: $copyFromPath"

    # copy to local.
    local copyToPath="${BACKUP_DIR}/${PROJECT_NAME}/${STAGE_TO}/${PROJECT_NAME}-${STAGE_TO}-$(date +%Y-%m%d).sql"
    logInfo "copy to path  : $copyToPath"

    # copy.
    cp $copyFromPath $copyToPath

    # log.
    if [ $? -eq 0 ]; then
        logSuccess "copy_staging_to_local.sh successful: ${copyToPath}"
    else
        logError "copy_staging_to_local.sh failed: ${copyToPath}"
    fi
}

main