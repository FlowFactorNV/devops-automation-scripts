# Ansible: System confifuration automation

Last stable Ansible version: `>=2.9.xx`
Best to be used with ansible navigator

This Ansible setup helps manage and keep systems in check across different machines. 
It's built around a main playbook (shared.yml) that handles various system tasks like 
checking if DNS is working, managing user access, and setting up system accounts. 
The setup works with different Linux systems, including RHEL and Ubuntu, and can be run
on specific machines or groups of machines as needed.

## Source location

The master source code is located at:
```
https://github.com/FlowFactorNV/devops-automation-scripts.git
```

Feel free to fork the repository and create a pull requests.

## Working with the cloned repository

### Cloning the repository

Use following command to clone your fork locally:

```bash
git clone git@github.com:<your github user name>/devops-automation-scripts.git --recursive
```

### Updating the repository
- Adding the original repository as a remote:

```bash
git remote add upstream https://github.com/FlowFactorNV/devops-automation-scripts.git
```

- Update the repository with the latest changes from the master branch:

```bash
git fetch upstream -v
git checkout master
git merge upstream/master
```

### Working with branches
Create a new local branch:
```bash
git checkout -b <new_branch_name>
```

### Committing changes
Add local changes, commit them and push to your fork:
```bash
git add <changed_files>
git commit -ve
git push
```

## Usefully Ansible commands

### List all facts from a host:

```bash
ansible -m setup hostname
```

### List Ansible configuration

```bash
ansible-config dump --only-changed
ansible-config dump
```

## Execute a playbook

### All host specified in playbook

```bash
ansible-playbook <filename>.yml
```

### Limited to a certain host

```bash
ansible-playbook <filename>.yml -l <hostname>
```

### Limited to a host and role

```bash
 ansible-playbook <filename>.yml -l <hostname>  -t <role name>
```

#### Usefull options:

```bash
 --check       # Dry-run
--list-tasks  # Show all tasks to execute
--list-hosts  # Show all hosts involved
-v[vv]        # Verbose level. More 'v' instances is more detail
```

### Ansible run for specific customer

```bash
ansible-playbook api.yml -i hosts/acc-admin --skip-tags source
```

### Example Ansible run commands

```bash
ansible-playbook <filename>.yml -l <ansible host group name|fqdn>  --check
ansible-playbook <filename>.yml -l <ansible host group name|fqdn> -t timezone
ansible-playbook <filename>.yml -l <ansible host group name|fqdn> -t check_rhns,rhn_register --check --diff
```

#### Encrypt a string

```bash
ansible-vault encrypt_string --stdin-name 'new_user_password'
ansible-vault encrypt_string  <string>
```
### Ansible Navigator running with vault password file

```bash
ansible-navigator run shared --vault-pass-file .vault
```

### Add a temporary IP to a host for Install

```bash
ansible_host=192.168.0.99
```
