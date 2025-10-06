#!/bin/zsh

function exportApiGatewayPostgresql() {
    local backupStageDir="${backupDir}/${projectName}/${localStage}"
    mkdir -p $backupStageDir

    local exportFullPath="${backupStageDir}/${projectName}-${localStage}-gateway-$(date +%Y-%m%d).sql"

    local psqlCommand="pg_dump -h $localDbHost -p $localDbPort -U $localGatewayDbUser -d $localGatewayDbName > $exportFullPath"
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # export.
    exportApiGatewayPostgresql

    logSuccess "local_gateway_export.sh successful"
}

# Main process.
source ./script__sql/base/main.sh
main