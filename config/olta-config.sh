# ==================================================================
# OLTA config.
# ==================================================================
### replace stg <--> local db user name.
searchPattern="" # please set.
replacementPattern="" # please set.
### staging.
stagingDbHost="" # please set.
stagingDbName="" # please set.
stagingDbPassword="" # please set.
stagingDbPort="5432"
stagingDbSchema="" # please set.
stagingDbUser="" # please set.
stagingGatewayDbName="" # please set.
stagingGatewayDbSchema="" # please set.
stagingGatewayDbUser="" # please set.
stagingStage="staging"
### local.
localDbHost="127.0.0.1"
localDbName="regolith"
localDbPassword="Passw0rd"
localDbPort="5010"
localDbSchema="regolith_schema"
localDbUser="regolith_user"
localGatewayDbName="regolith_gateway"
localGatewayDbSchema="regolith_gateway_schema"
localGatewayDbUser="regolith_gateway_user"
localStage="local"