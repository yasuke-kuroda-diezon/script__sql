# ==================================================================
# ▼ main functions.
# ==================================================================

# config.sh を読み込み
source ./script__sql/config/config.sh
source ./script__sql/lib/log.sh
source ./script__sql/lib/task.sh

# projectName に応じて追加設定ファイルを読み込み
case "$projectName" in
    "headless")
        source ./script__sql/config/headless-config.sh
        ;;
    "olta")
        source ./script__sql/config/olta-config.sh
        ;;
    *)
        logError "Unknown projectName: $projectName"
        logError "config.sh > projectName には"headless"または"olta"を指定してください."
        exit 1
        ;;
esac

function main() {
    logInfo "Script Start."

    runTaskCalledByMain

    echo "\n"
    logInfo "Script End."
}