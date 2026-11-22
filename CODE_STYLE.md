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

A task that departs from a repo convention or a module default carries a one-line comment with the reason: `ignore_errors`, `pull: always`, a user unit where others are system units, a `register` that nothing reads. Keep the reason generic when the real one is private (see the Secrets section of AGENTS.md).
