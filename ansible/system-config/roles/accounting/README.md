# Ansible Role: Accounting

Install process accounting and system performance monitoring tools.

## Requirements

No requirements

## Role Variables

### psacct_packages

List of process accounting packages to install, loaded from OS dependant vars files.

### psacct_package_state

Process accounting packages install state.

Possible values:
- `present`
- `absent`

Default: `present`

### psacct_service_name

Process accounting service name, loaded from OS dependant vars files.

### psacct_service_state

Process accounting service startup state.

Possible values:
- `started`
- `stopped`

Default: `started`

### psacct_service_enabled

Process accounting service enabled state.

Possible values:
- `yes`
- `no`

Default: `yes`

### sysstat_packages:

List of system performance monitoring tools packages to install, loaded from OS dependant vars files.

### sysstat_package_state

System performance monitoring tools packages install state.

Possible values:
- `present`
- `absent`

Default: `present`

### sysstat_service_name

System performance monitoring tools service name, loaded from OS dependant vars files.

### sysstat_service_state

System performance monitoring tools service startup state.

Possible values:
- `started`
- `stopped`

Default: `started`

### sysstat_service_enabled

System performance monitoring tools service enabled state.

Possible values:
- `yes`
- `no`

Default: `yes`

## Dependencies

No dependencies.

## Example Playbook

```
    - hosts: servers
      roles:
        - role: framed.accounting
```
