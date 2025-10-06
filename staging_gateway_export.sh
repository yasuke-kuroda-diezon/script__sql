#!/bin/zsh

function exportGatewayPostgresql() {
    local backupStageDir="${backupDir}/${projectName}/${stagingStage}"
    mkdir -p $backupStageDir

    local exportFullPath="${backupStageDir}/${projectName}-${stagingStage}-gateway-$(date +%Y-%m%d).sql"

    local psqlCommand="pg_dump -h $stagingDbHost -p $stagingDbPort -U $stagingDbUser -d $stagingGatewayDbName > $exportFullPath"
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$stagingDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # export.
    exportGatewayPostgresql

    logSuccess "staging_gateway_export.sh successful"
}

# Main process.
source ./script__sql/base/main.sh
main