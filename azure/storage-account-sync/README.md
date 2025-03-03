# Azure / Storage account sync

Synchronizes containers from a set of storage accounts to another set of storage accounts using the azcopy tool.
For more info, run `./sa-sync.sh --help`.

## Examples

### Run locally

```shell
./sa-sync.sh \
   --source-subscription prdSubscription  \
   --target-subscription drSubscription \
   --source-sas exampleprd,example2prd \
   --target-sas exampledr,example2dr \
   --excluded-containers \$logs,\$web,errors
```

### Run in Azure Pipelines

Here is an example Azure Pipelines job that runs the script:

```yaml
jobs:
- job: RunSyncScriptAcc
  displayName: 'Run storage account sync script
  pool:
    vmImage: 'ubuntu-latest'
  variables:
    sourceSubscription: prdSubscription
    targetSubscription: drSubscription
    sourceSAs: "exampleprd,example2prd"
    targetSAs: "exampledr,example2dr"
    excludedContainers: "$logs,$web,errors"
  steps:
  - task: AzureCLI@2
    displayName: 'Run sync script for ACC SAs'
    inputs:
      azureSubscription: <fill-in>
      scriptType: bash
      scriptPath: ./sa-sync.sh
      arguments: "--source-subscription $(sourceSubscription) --target-subscription $(targetSubscription) --source-sas $(sourceSAs) --target-sas $(targetSAs) --excluded-containers $(excludedContainers)"
      failOnStandardError: true
```
