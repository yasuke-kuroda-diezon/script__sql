#!/bin/zsh

# load functions.
source ./script_sql/functions/log.sh

# ▼ config
local BACKUP_DIR="/Users/yasuke_kuroda/Documents/db_backup"
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

function getLatestSqlFile() {
    local dir=$1
    ls -rtl $dir | grep -E "${PROJECT_NAME}-${STAGE}-.*\.sql" | tail -n 1 | awk '{print $9}'
}

function deleteRegolithTable() {
    local command="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \"DO \\\$\\\$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = '$DB_SCHEMA') LOOP
        EXECUTE 'DROP TABLE $DB_SCHEMA.' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END \\\$\\\$;\""
    logInfo "$command"

    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function deleteRegolithTypes() {
    local command="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \"DO \\\$\\\$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT typname
        FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
        WHERE n.nspname = '$DB_SCHEMA'
          AND t.typtype = 'e'
    ) LOOP
        EXECUTE 'DROP TYPE $DB_SCHEMA.' || quote_ident(r.typname) || ' CASCADE';
    END LOOP;
END \\\$\\\$;\""
    logInfo "$command"

    export PGPASSWORD=$DB_PASS
    eval $command
    unset PGPASSWORD
}

function main() {
    # delete all types.
    deleteRegolithTypes

    # delete all tables.
    deleteRegolithTable

    # log.
    if [ $? -eq 0 ]; then
        logSuccess "delete_local_sql.sh successfully."
    else
        logError "delete_local_sql.sh failed."
    fi
}

main
