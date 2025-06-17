# GitLab / AWS Terraform Pipeline

We have three AWS accounts in question for projects that use this pipeline, one for development, one for production
and one that contains an S3 bucket that stores the state files for our Terraform projects.

Each account is configured with an OpenID Connect provider for gitlab.com, and a role that the pipeline's runner will 
assume. These are saved as `STATE_AWS_ROLE_ARN`, `DEV_AWS_ROLE_ARN` and `PRD_AWS_ROLE_ARN` in hidden and masked CI variables.


