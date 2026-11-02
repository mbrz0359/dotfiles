# Code style

## Tasks

Separate tasks and handlers with a blank line. A comment about a task goes directly above it, after the blank line.

```yaml
---
- name: Git config
  ansible.builtin.include_tasks: git.yml

# Public SSH keys trusted to sign commits
- name: Git allowed signers
  ansible.builtin.include_tasks: allowed-signers.yml
```
