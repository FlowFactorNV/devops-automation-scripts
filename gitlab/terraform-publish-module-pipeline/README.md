# GitLab / Terraform publish module pipeline

This pipeline validates and publishes Terraform modules to the GitLab module registry. I use it to publish smaller 
modules that are bundled together in the same repository. For example, consider the following directories containing
modules for AWS:

```
.
├── app-runner
├── bastion
├── buckets
├── cloudfront
├── iam-assume-role
├── iam-policy
├── rds
├── secrets-manager
├── security-group
├── ssm
└── vpc
```

When I want to release a new version of one of these modules, I simply push a new tag in the following format: `<module-name>/vX.Y.Z`
where X, Y and Z form the semantic version number. The pipeline takes care of the rest.
