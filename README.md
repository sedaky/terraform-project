# terraform-project

#### Terraform uses a different set of credentials to provide the infrastructure, so you need to create them first for required environments.

* ``az login``
* ``az account list``
* ``az account set --subscription "SUBSCRIPTION_ID"``
* ``az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"``

**The above command should print a JSON payload like this:**
* ``
{
"appId": "00000000-0000-0000-0000-000000000000", (client_id)
"displayName": "azure-cli-XXX",
"name": "http://azure-cli-XXX",
"password": "0000-0000-0000-0000-000000000000", (client_secret)
"tenant": "00000000-0000-0000-0000-000000000000" (tenant_id)
}
``
#### You need those to set up Terraform. Assign it to the variables in the variable.tf file.

