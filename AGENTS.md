# AGENTS.md

Ansible playbook for my machines. **This repository is public on GitHub.** Treat
everything committed as published.

## Layout

- `local.yml`: one play per inventory group. `fedora` (parent of `desktop` and
  `work`) has the shared roles, then `desktop` and `work` add their own, then `pi`.
  Keep role lists alphabetical.
- `hosts`: inventory. `ayem` is the Raspberry Pi. Hostnames match inventory names.
- `group_vars/{all,fedora,desktop,work,pi}.yml`: variables, including inline vault-encrypted secrets.
- `backups/`: settings the playbook can't apply (see README.md). No role uses them.
- `roles/<name>/tasks/main.yml`: one role per app or tool. Group differences are
  data, not task files: a role keeps the common list in `defaults/` (e.g.
  `apps_flatpaks`) and an empty `<role>_group_<list>` that `group_vars/<group>.yml`
  fills. Files for one group or host are named after it (`files/zsh/<group|host>/`,
  `cli-tools-<group>.toml`), and a loop over `group_names` copies the ones that exist.

## Running

The agent's shell is bash and doesn't load the zsh config, so set the vault
password source first:

```sh
export ANSIBLE_VAULT_IDENTITY_LIST="default@$PWD/vault-keyring-client.sh"
```

- ayem (over SSH, passwordless sudo): `ansible-playbook local.yml -l ayem [--check]`
- Local desktop: `ansible-playbook local.yml -l maciej-pc -K` needs my sudo password
  (`hosts` sets a local connection for it). Ask me to run it.
- CI (`.github/workflows/ci.yml`) runs `ansible-lint` (profile `production`, see
  `.ansible-lint`; it includes the syntax check) and the Renovate config validator, in a
  `fedora:45` container with Fedora's `ansible-core` and `python3-ansible-lint`. Run
  `env -u ANSIBLE_VAULT_IDENTITY_LIST ansible-lint --offline` before committing; it uses
  the same packages, installed by dnf. Like CI, it runs without the vault password: with
  it, the parallel syntax checks query the keyring and fail at random.
  Do a `--check` run against ayem for changes to the `pi` play.

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
- Collections come from Galaxy (`ansible-pull.service` installs the versions pinned
  in `requirements.yml`), not Debian.

## Conventions

- Follow [CODE_STYLE.md](CODE_STYLE.md) for formatting.
- Containers: `community.docker.docker_container`, `become: true`, data under
  `{{ ansible_docker_dir }}/<app>`, `restart_policy: unless-stopped`. Set
  `PUID`/`PGID` `1000` and `TZ: "{{ timezone }}"` only for images that use them.
- Pin image tags (not `latest`) so Renovate can update them. Renovate automerges
  minor/patch updates; majors get a PR.
- systemd services I should hear about when they fail get
  `OnFailure=unit-status@%n.service` (notifies Home Assistant).

## Git

- Ask before committing. Commits go to `main`.
- Imperative subject line, short body explaining why.
