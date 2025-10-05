#!/bin/zsh

# load functions.
source ./script_sql/functions/log.sh

# ▼ config
## ▼ headless.
local PROJECT_NAME="headless"
local STAGE="local"
local DB_HOST="127.0.0.1"
local DB_PORT="5000"
local DB_USER="regolith_user"
local DB_NAME="regolith"
local DB_SCHEMA="regolith_schema"
local DB_PASS="Passw0rd"
local GATEWAY_DB_USER="regolith_gateway_user"
local GATEWAY_DB_NAME="regolith_gateway"
local GATEWAY_DB_SCHEMA="regolith_gateway_schema"
## ▼ olta.
# local PROJECT_NAME="olta"
# local STAGE="local"
# local DB_HOST="127.0.0.1"
# local DB_PORT="5010"
# local DB_USER="regolith_user"
# local DB_NAME="regolith"
# local DB_SCHEMA="regolith_schema"
# local DB_PASS="Passw0rd"
# local GATEWAY_DB_USER="regolith_gateway_user"
# local GATEWAY_DB_NAME="regolith_gateway"
# local GATEWAY_DB_SCHEMA="regolith_gateway_schema"

function catRegolithType() {
    local command="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \"SELECT n.nspname AS schema_name, t.typname AS type_name
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = 'regolith_schema'
 AND t.typtype = 'e';\""
    logInfo "$command"

    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function catRegolithGatewayType() {
    local command="psql -h $DB_HOST -p $DB_PORT -U $GATEWAY_DB_USER -d $GATEWAY_DB_NAME -c \"SELECT n.nspname AS schema_name, t.typname AS type_name
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = '$GATEWAY_DB_SCHEMA';\""
    logInfo "$command"

    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function catRegolithTable() {
    local command="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \"SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = 'regolith_schema';\""
    logInfo "$command"

    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function catRegolithGatewayTable() {
    local command="psql -h $DB_HOST -p $DB_PORT -U $GATEWAY_DB_USER -d $GATEWAY_DB_NAME -c \"SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = '$GATEWAY_DB_SCHEMA';\""
    logInfo "$command"

    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function main() {
    # get and display types.
    catRegolithType
    catRegolithGatewayType

    # get and display tables.
    catRegolithTable
    catRegolithGatewayTable

    logSuccess "cat_local_sql successful."
}

main
