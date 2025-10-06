#!/bin/zsh

function getLatestGatewaySqlFilePath() {
    local dir=$1
    ls -rtl $dir | grep -E "${projectName}-${localStage}-gateway-.*\.sql" | tail -n 1 | awk '{print $9}'
}

function importGatewayPostgresql() {
    local backupStageDir="${backupDir}/${projectName}/${localStage}"
    logInfo "backupStageDir: $backupStageDir"

    # get latest import file.
    local sqlFile=$(getLatestGatewaySqlFilePath $backupStageDir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi

    local psqlCommand="cat ${backupStageDir}/${sqlFile} | psql -h $localDbHost -p $localDbPort -U $localGatewayDbUser -d $localGatewayDbName"
    logInfo "$psqlCommand"

    # 環境変数PGPASSWORDをsetすることでパスワー入力を省略する.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # import.
    importGatewayPostgresql

    logSuccess "local_gateway_import.sh successfully."
}

# Main process.
source ./script__sql/base/main.sh
main