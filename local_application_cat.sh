#!/bin/zsh

function catApplicationType() {
    local psqlCommand="psql -h $localDbHost -p $localDbPort -U $localDbUser -d $localDbName -c \"SELECT n.nspname AS schema_name, t.typname AS type_name FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = '$localDbSchema' AND t.typtype = 'e';\""
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

function catApplicationTable() {
    local psqlCommand="psql -h $localDbHost -p $localDbPort -U $localDbUser -d $localDbName -c \"SELECT schemaname, tablename FROM pg_tables WHERE schemaname = '$localDbSchema';\""
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # regolith.
    catApplicationType
    catApplicationTable

    logSuccess "local_application_cat.sh successful."
}

# Main process.
source ./script__sql/base/main.sh
main