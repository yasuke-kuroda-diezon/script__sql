#!/bin/zsh

function getLatestApplicationSqlFilePath() {
    local dir=$1
    ls -rtl $dir | grep -E "${projectName}-${localStage}-application-.*\.sql" | tail -n 1 | awk '{print $9}'
}

function importApplicationPostgresql() {
    local backupStageDir="${backupDir}/${projectName}/${localStage}"
    logInfo "backupStageDir: $backupStageDir"

    # get latest import file.
    local sqlFile=$(getLatestApplicationSqlFilePath $backupStageDir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi

    local psqlCommand="cat ${backupStageDir}/${sqlFile} | psql -h $localDbHost -p $localDbPort -U $localDbUser -d $localDbName"
    logInfo "$psqlCommand"

    # 環境変数PGPASSWORDをsetすることでパスワー入力を省略する.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # import.
    importApplicationPostgresql

    logSuccess "local_application_import.sh successfully."
}

# Main process.
source ./script__sql/base/main.sh
main