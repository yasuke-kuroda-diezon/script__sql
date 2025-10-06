#!/bin/zsh

function getLatestGatewaySqlFilePath() {
    local dir=$1
    ls -rtl $dir | grep -E "${projectName}-${localStage}-gateway-.*\.sql" | tail -n 1 | awk '{print $9}'
}

runTaskCalledByMain() {
    local backupStageDir="${backupDir}/${projectName}/${localStage}"
    logInfo "backupStageDir: $backupStageDir"

    # get latest import file.
    local sqlFile=$(getLatestGatewaySqlFilePath $backupStageDir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi

    # execute psqlCommand.
    local psqlCommand="sed -i '' 's/${searchPattern}/${replacementPattern}/g' ${backupStageDir}/${sqlFile}"
    logInfo "$psqlCommand"

    # 環境変数PGPASSWORDをsetすることでパスワー入力を省略する.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD

    logSuccess "rename_gateway_db_user_stg_to_local.sh successfully."
}

# Main process.
source ./script__sql/base/main.sh
main