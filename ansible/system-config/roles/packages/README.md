# ansible-packages

Ansible role to install packages on a host

## Ansible requirements

### Ansible version

Minimum required ansible version is 2.0.

### Ansible role dependencies

None.

## Installation

### Install with Ansible Galaxy

```shell
ansible-galaxy install archf.packages
```

Basic usage is:

```yaml
- hosts: all
  roles:
    - role: archf.packages
```

### Install with git

If you do not want a global installation, clone it into your `roles_path`.

```shell
git clone git@github.com:archf/ansible-packages.git /path/to/roles_path
```

But I often add it as a submdule in a given `playbook_dir` repository.

```shell
git submodule add git@github.com:archf/ansible-packages.git <playbook_dir>/roles/packages
```

As the role is not managed by Ansible Galaxy, you do not have to specify the
github user account.

Basic usage is:

```yaml
- hosts: all
  roles:
  - role: packages
```
## User guide

### Introduction

Ansible role to perform:

- `/etc/sudoers` adjustement
  - disable `requiretty` to allow enabling ansible pipelining (faster execution)
  - disable `always_set_home` (allow running `sudo -E` and avoids `sudo make install` issues)
  - prepend `/usr/local/bin` to `secure_path` to allow running priviledged compiled programs
- install default packages
- configure repositories (currently only yum repos)
- configure yum or dnf repository
- disable/enable selinux on rhel
- add mounts in the fstree

A lot of things are hardcoded for now.

### Usage

**Adding mounts to fstab**

This is using the Ansible `mount` module.

```yaml
mounts:
  - dev: '/dev/mapper/data_vg-home_lv'
    path: '/media/home_lv'
    state: mounted
    fstype: ext4
    opts: 'defaults,acl'
    group: users
    passno: X # defaults to 2
    dump: Y # defaults to 1
```

**Configure Repos on RedHat and derivatives**

This structure allows you to group repos on a per file basis.

```yaml
packages_repos:
- file: base
  repos:
    - name: base
      baseurl: "http://<your host>/centos/$releasever/os/$basearch"

    - name: updates
      baseurl: "http://<your host>/centos/$releasever/updates/$basearch"

    - name: extras
      baseurl: "http://<your host>/centos/$releasever/extras/$basearch"

    - name: contrib
      baseurl: "http://<your host>/centos/$releasever/contrib/$basearch"

    - name: centosplus
      baseurl: "http://<your host>/centos/$releasever/centosplus/$basearch"

- file: epel
  repos:
    - name: epel
      baseurl: "http://<your host>/epel/$releasever/$basearch"
```


## Role Variables

Variables are divided in three types.

The [default vars](#default-vars) section shows you which variables you may
override in your ansible inventory. As a matter of fact, all variables should
be defined there for explicitness, ease of documentation as well as overall
role manageability.

The [mandatory variables](#mandatory-variables) section contains variables that
for several reasons do not fit into the default variables. As name implies,
they must absolutely be defined in the inventory or else the role will
fail. It is a good thing to avoid reach for these as much as possible and/or
design the role with clear behavior when they're undefined.

The [context variables](#context-variables) are shown in section below hint you
on how runtime context may affects role execution.

### Default vars

Role default variables from `defaults/main.yml`.

```yaml
# Packages installation behavior.
packages_state: latest

# Selinux state.
packages_selinux_state: disabled

```

### Mandatory variables

None.

### Context variables

Those variables from `vars/*.{yml,json}` are loaded dynamically during task
runtime using the `include_vars` module.

Variables loaded from `vars/CentOS.yml`.

```yaml
# List of packages to install by default on any CentOS family system
common_pkgs:
  - urlview
  - sudo
  - git
  - tree
  - openssh-server
  - gdisk
  - rsync
  - lvm2
  - ncurses-devel
  - ncurses
  - nmap
  - vim-common
  - vim-X11
  - vim-enhanced
  - zsh
  - curl
  - wget
  - libselinux-python
  - man
  - tcpdump
  - iotop
  - iftop
  - strace
  - mlocate
  - unzip
  # versatile replacement for vmstat, iostat and ifstat
  - dstat
  - yum-utils
  # - sysstat
  # - tmux

  # requires epel-release packages on CentOS
  # - htop
  # - python34
  # - sshpass

```

Variables loaded from `vars/Debian.yml`.

```yaml
# List of packages to install by default on any debian family system.
common_pkgs:
  - tmux
  - urlview
  - mosh
  - git
  - vim-gtk3
  - vim
  - htop
  - fakeroot
  - tree
  - openssh-server
  - gdisk
  - rsync
  - lvm2
  - libncurses5-dev
  - libncurses5
  - nmap
  - linux-kernel-headers
  - zsh
  - ssh-askpass
  - sshpass
  - curl
  - wget
  - python-selinux
  - python3
  - python3-venv
  - tcpdump
  - iotop
  - iftop
  - strace
  - mlocate
  - unzip
  # versatile replacement for vmstat, iostat and ifstat
  - dstat
  - pv
  - progress
  - xauth
  # - sysstat
  # - ntopng

```

Variables loaded from `vars/RedHat.yml`.

```yaml
# List of packages to install by default on any rhel family system.
common_pkgs:
  - urlview
  - mosh
  - sudo
  - git
  - tree
  - openssh-server
  - gdisk
  - rsync
  - lvm2
  - ncurses-devel
  - ncurses
  - nmap
  - vim-common
  - vim-X11
  - zsh
  - curl
  - wget
  - libselinux-python
  - man
  - tcpdump
  - iotop
  - iftop
  - strace
  - mlocate
  - unzip
  # versatile replacement for vmstat, iostat and ifstat
  - dstat
  - yum-utils
  - xorg-x11-xauth
  # - sysstat
  # - tmux
  # - htop
  # - python3

```
