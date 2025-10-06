#!/bin/zsh

function exportApplicationPostgresql() {
    local backupStageDir="${backupDir}/${projectName}/${localStage}"
    mkdir -p $backupStageDir

    local exportFullPath="${backupStageDir}/${projectName}-${localStage}-application-$(date +%Y-%m%d).sql"

    local psqlCommand="pg_dump -h $localDbHost -p $localDbPort -U $localDbUser -d $localDbName > $exportFullPath"
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # export.
    exportApplicationPostgresql

    logSuccess "local_application_export.sh successful"
}

# Main process.
source ./script__sql/base/main.sh
main