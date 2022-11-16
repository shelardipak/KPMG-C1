az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"
az account set -s "$ARM_SUBSCRIPTION_ID"


    #Terraform command to initialise the terraform
    terraform -chdir=environment/${TARGET_ENVIRONMENT} init -backend-config="container_name=terraform" -backend-config="key=${TARGET_ENVIRONMENT}-${SHORT_LOCATION}-cl${CLAIMSDATAPLATFORMENV}.tfstate" -backend-config="resource_group_name=rg-${CI_PROD_NONPROD}-${SHORT_LOCATION}-${CI_ENVIRONMENT}-core" -backend-config="storage_account_name=stg${CI_PROD_NONPROD}${SHORT_LOCATION}${CI_ENVIRONMENT}${TARGET_ENVIRONMENT}state" -backend-config="subscription_id=${CI_SUBSCRIPTION_ID}"

    terraform -chdir=environment/${TARGET_ENVIRONMENT} plan -var-file="terraform.tfvars"  -out="terraform.tfplan"

    #Terraform command to deploy the terraform
    terraform -chdir=environment/${TARGET_ENVIRONMENT} apply terraform.tfplan

    terraform output
