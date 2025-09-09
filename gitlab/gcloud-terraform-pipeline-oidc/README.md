# GitLab / Google Cloud Terraform Pipeline with OIDC

This is a GitLab CI/CD pipeline to run Terraform jobs with GitLab backed state to provision resources in Google Cloud.
I use it to deploy general infrastructure. It uses Workload Identity Federation (WIF) for authentication, which is 
certainly safer than using service account keys (as shown in the `gitlab/gcloud-terraform-pipeline-sa` example).

The pipeline assumes that you have a Workload Identity Pool, a Workload Identity Provider and Service Account configured
in Google Cloud with `https://gitlab.com` as audience.

The pipeline requires the following CI/CD variables to be configured:

| Name                         | Value                                                                                                                                                                    |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `GITLAB_USERNAME`            | Username of the GitLab tenant (user or service account) that the pipeline assumes to access the Terraform state.                                                         |
| `GITLAB_ACCESS_TOKEN`        | Access token for the GitLab tenant (user or service account) that the pipeline uses to authenticate.                                                                     |
| `PROJECT_ID`                 | The Google Cloud project ID where the resources will be provisioned.                                                                                                     |
| `SERVICE_ACCOUNT`            | The service account to be assumed via Workload Identity Federation.                                                                                                      |
| `WORKLOAD_IDENTITY_PROVIDER` | The resource path to the Google Cloud workload identity provider, e.g. projects/<project-number>/locations/global/workloadIdentityPools/gitlab/providers/<provider-name> |
