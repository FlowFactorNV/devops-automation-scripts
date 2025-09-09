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
- disable selinux on rhel
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
