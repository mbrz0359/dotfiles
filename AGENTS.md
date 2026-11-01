# AGENTS.md

Ansible playbook for my machines. **This repository is public on GitHub.** Treat
everything committed as published.

## Layout

- `local.yml`: one play per inventory group (`desktop`, `work`, `pi`). Keep role
  lists alphabetical.
- `hosts`: inventory. `ayem` is the Raspberry Pi. Hostnames match inventory names.
- `group_vars/{all,pi}.yml`: variables, including inline vault-encrypted secrets.
- `roles/<name>/tasks/main.yml`: one role per app or tool. Host-specific files go
  in `files/<inventory_hostname>/`, group-specific tasks use
  `when: "'<group>' in group_names"`.

## Running

The agent's shell is bash and doesn't load the zsh config, so set the vault
password source first:

```sh
export ANSIBLE_VAULT_IDENTITY_LIST="default@$PWD/vault-keyring-client.sh"
```

- Syntax check: `ansible-playbook --syntax-check local.yml`
- ayem (over SSH, passwordless sudo): `ansible-playbook local.yml -l ayem [--check]`
- Local desktop: `ansible-playbook local.yml -l maciej-pc -K` needs my sudo password
  (`hosts` sets a local connection for it). Ask me to run it.
- CI (`.github/workflows/ci.yml`) runs `--syntax-check`, `ansible-lint` (profile `production`,
  see `.ansible-lint`) and the Renovate config validator. Run `ansible-lint` locally before
  committing, plus a `--check` run against ayem for changes to the `pi` play.

## Secrets

- Secrets are inline `!vault` values in `group_vars`. LAN IP addresses count as
  secrets (see `lan_hosts`).
- Never print decrypted values. Don't run `--diff` over tasks that template secrets
  (docker `env`/`command`, `/etc/unit-status.env`). Verify with
  `length` or `hash('sha256')` instead.
- To encrypt a value I give you, pipe it into
  `ansible-vault encrypt_string --stdin-name <var>` without echoing it. When I
  encrypt one myself, suggest `wl-paste -n | ansible-vault encrypt_string --stdin-name <var>`
  and check the result has no trailing newline.

## ayem

- `ansible-pull` applies `main` from GitHub nightly at 04:00. Changes deployed to
  ayem from a local checkout are reverted that night unless they're pushed.
- Pi-hole provides LAN DNS. Recreating its container or rebooting ayem (the
  `raspberry-pi` role reboots on cmdline changes) briefly takes DNS down.
- Collections come from Galaxy (`ansible-pull.service` upgrades them), not Debian.

## Conventions

- Containers: `community.docker.docker_container`, `become: true`, data under
  `{{ ansible_docker_dir }}/<app>`, `PUID`/`PGID` `1000`, `TZ: "{{ timezone }}"`,
  `restart_policy: unless-stopped`.
- Pin image tags (not `latest`) so Renovate can update them. Renovate automerges
  minor/patch updates; majors get a PR.
- systemd services I should hear about when they fail get
  `OnFailure=unit-status@%n.service` (notifies Home Assistant).

## Git

- Ask before committing or pushing. Commits go to `main`.
- Imperative subject line, short body explaining why.
