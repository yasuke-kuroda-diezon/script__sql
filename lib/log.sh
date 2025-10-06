# ==================================================================
# ▼ log/print functions.
# ==================================================================
# @param string $successMessage
function logSuccess() {
    local successMessage=$1
    local green="\e[32m"
    local endColor="\e[0m" # reset color.

    echo -e "${green}[SUCCESS]: ${successMessage}${endColor}"
}

# @param string $WarningMessage
function logWarning() {
    local warningMessage=$1
    local yellow="\e[33m"
    local endColor="\e[0m" # reset color.

    echo -e "${yellow}[WARNING]: ${warningMessage}${endColor}"
}

# @param string $errorMessage
function logError() {
    local errorMessage=$1
    local red="\e[31m"
    local endColor="\e[0m" # reset color.

    echo -e "${red}[ERROR]: ${errorMessage}${endColor}"
}

# @param string $infoMessage
function logInfo() {
    local infoMessage=$1
    local cyan="\e[36m"
    local endColor="\e[0m" # reset color.

    echo -e "${cyan}[INFO]: ${infoMessage}${endColor}"
}