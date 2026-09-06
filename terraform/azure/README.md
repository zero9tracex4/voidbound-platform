# Azure Terraform

Terraform configuration for the VoidBound Platform Azure environment.

## Authentication

Local Terraform operations use the Azure CLI session.

Login if required:

```bash
az login
```

Enable Azure CLI authentication for the AzureRM backend:

```bash
export ARM_USE_CLI=true
```

## Initialize

```bash
terraform init
```

## Common workflow

Check formatting:

```bash
terraform fmt -check
```

Validate the configuration:

```bash
terraform validate
```

Review proposed infrastructure changes:

```bash
terraform plan
```

## Remote state

Terraform state is stored remotely in Azure Blob Storage.

Backend:

- Storage account: `stvoidboundtf791a86`
- Container: `tfstate`
- State key: `voidbound-platform/dev.tfstate`
- Authentication: Microsoft Entra ID / Azure CLI

Local Terraform state files must not be committed to Git.
