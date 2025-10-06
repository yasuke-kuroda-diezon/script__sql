#!/bin/zsh

function deleteGatewayTables() {
    local psqlCommand="psql -h $localDbHost -p $localDbPort -U $localGatewayDbUser -d $localGatewayDbName -c \"DO \\\$\\$ DECLARE r RECORD; BEGIN FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = '$localGatewayDbSchema') LOOP EXECUTE 'DROP TABLE $localGatewayDbSchema.' || quote_ident(r.tablename) || ' CASCADE'; END LOOP; END \\\$\\$;\""
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

function deleteGatewayTypes() {
    local psqlCommand="psql -h $localDbHost -p $localDbPort -U $localGatewayDbUser -d $localGatewayDbName -c \"DO \\\$\\$ DECLARE r RECORD; BEGIN FOR r IN ( SELECT typname FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = '$localGatewayDbSchema' AND t.typtype = 'e') LOOP EXECUTE 'DROP TYPE $localGatewayDbSchema.' || quote_ident(r.typname) || ' CASCADE'; END LOOP; END \\\$\\$;\""
    logInfo "$psqlCommand"

    # パスワード入力省略のため、一度環境変数に設定し、実行後クリアとする.
    export PGPASSWORD=$localDbPassword
    eval $psqlCommand
    unset PGPASSWORD
}

runTaskCalledByMain() {
    # delete type && table.
    deleteGatewayTypes
    deleteGatewayTables

    logSuccess "local_gateway_delete.sh successfully."
}

# Main process.
source ./script__sql/base/main.sh
main
