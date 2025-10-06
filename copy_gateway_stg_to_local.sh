#!/bin/zsh

function getLatestGatewaySqlFilePath() {
    local dir=$1
    ls -rtl $dir | grep -E "${projectName}-${stagingStage}-gateway-.*\.sql" | tail -n 1 | awk '{print $9}'
}

runTaskCalledByMain() {
    # from staging.
    local copyFromStageDir="${backupDir}/${projectName}/${stagingStage}"

    # get latest import file.
    local sqlFile=$(getLatestGatewaySqlFilePath $copyFromStageDir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi

    local copyFromFullPath="${copyFromStageDir}/${sqlFile}"
    logInfo "copy from full path: $copyFromFullPath"

    local copyToFullPath="${backupDir}/${projectName}/${localStage}/${projectName}-${localStage}-gateway-$(date +%Y-%m%d).sql"
    logInfo "copy to full path  : $copyToFullPath"

    # copy.
    cp $copyFromFullPath $copyToFullPath

    logSuccess "copy_gateway_stg_to_local.sh successful: ${copyToFullPath}"
}

# Main process.
source ./script__sql/base/main.sh
main