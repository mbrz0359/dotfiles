# dotfiles

Ansible playbook (`local.yml`) for my machines.

## Ansible Vault password

The vault password is stored in GNOME Keyring and read by
[`vault-keyring-client.sh`](vault-keyring-client.sh). The `zsh` role sets
`ANSIBLE_VAULT_IDENTITY_LIST` to use it, so no vault flags are needed.

### Setup

```sh
# Store the password (from KeePassXC); secret-tool prompts for it
secret-tool store --label='Ansible vault (default)' service ansible-vault vault-id default

# First run, before the zsh config is deployed
ansible-playbook --vault-id default@./vault-keyring-client.sh local.yml -K

# Verify decryption (prints true)
ansible localhost -m debug -a 'msg={{ keepass_psw | length > 0 }}'
```

To add another vault ID, store it with `vault-id <id>` and append
`,<id>@$HOME/Workspace/dotfiles/vault-keyring-client.sh` to `ANSIBLE_VAULT_IDENTITY_LIST`.
