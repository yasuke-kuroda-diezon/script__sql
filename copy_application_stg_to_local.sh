#!/bin/zsh

function getLatestApplicationSqlFilePath() {
    local dir=$1
    ls -rtl $dir | grep -E "${projectName}-${stagingStage}-application-.*\.sql" | tail -n 1 | awk '{print $9}'
}

runTaskCalledByMain() {
    # from staging.
    local copyFromStageDir="${backupDir}/${projectName}/${stagingStage}"

    # get latest import file.
    local sqlFile=$(getLatestApplicationSqlFilePath $copyFromStageDir)
    if [ -z "$sqlFile" ]; then
        logWarning "No SQL file found in the directory."
        exit 1
    fi

    local copyFromFullPath="${copyFromStageDir}/${sqlFile}"
    logInfo "copy from full path: $copyFromFullPath"

    local copyToFullPath="${backupDir}/${projectName}/${localStage}/${projectName}-${localStage}-application-$(date +%Y-%m%d).sql"
    logInfo "copy to full path  : $copyToFullPath"

    # copy.
    cp $copyFromFullPath $copyToFullPath

    logSuccess "copy_application_stg_to_local.sh successful: ${copyToFullPath}"
}

# Main process.
source ./script__sql/base/main.sh
main