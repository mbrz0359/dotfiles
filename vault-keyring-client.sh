#!/bin/sh
# Ansible vault password client backed by GNOME Keyring (libsecret).
#
# Ansible runs scripts named "*-client*" with "--vault-id <id>" and reads the
# password from stdout. See README.md ("Ansible Vault password") for setup.
set -eu

vault_id=default
while [ $# -gt 0 ]; do
    case "$1" in
        --vault-id) vault_id="$2"; shift 2 ;;
        --vault-id=*) vault_id="${1#*=}"; shift ;;
        *) shift ;;
    esac
done

if ! secret-tool lookup service ansible-vault vault-id "$vault_id"; then
    echo "No Ansible vault password for vault-id '$vault_id' in the keyring." >&2
    echo "Store it with: secret-tool store --label='Ansible vault ($vault_id)' service ansible-vault vault-id $vault_id" >&2
    exit 1
fi
