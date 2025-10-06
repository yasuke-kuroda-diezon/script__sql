#!/bin/zsh

function catApiGatewayType() {
    local psqlCommand="psql -h $localDbHost -p $localDbPort -U $localGatewayDbUser -d $localGatewayDbName -c \"SELECT n.nspname AS schema_name, t.typname AS type_name FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = '$localGatewayDbSchema';\""
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

function catApiGatewayTable() {
    local psqlCommand="psql -h $localDbHost -p $localDbPort -U $localGatewayDbUser -d $localGatewayDbName -c \"SELECT schemaname, tablename FROM pg_tables WHERE schemaname = '$localGatewayDbSchema';\""
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    catApiGatewayType
    catApiGatewayTable

    logSuccess "local_gateway_cat.sh successful."
}

# Main process.
source ./script__sql/base/main.sh
main