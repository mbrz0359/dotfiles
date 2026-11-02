#!/usr/bin/env bash
# The repo's checks, run by CI (.github/workflows/ci.yml) and the pre-push hook (.githooks/pre-push).
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

venv=.venv-ci
requirements=.github/requirements-ci.txt
stamp="$venv/requirements.sha256"

# (Re)create the virtualenv when the pinned requirements change.
if [[ ! -f $stamp ]] || ! sha256sum --check --status "$stamp"; then
  echo "checks: installing $requirements into $venv"
  rm -rf "$venv"
  python3 -m venv "$venv"
  "$venv/bin/pip" install --quiet --disable-pip-version-check -r "$requirements"
  sha256sum "$requirements" > "$stamp"
fi
export PATH="$PWD/$venv/bin:$PATH"

# Local machines already have the collections; CI starts without them.
if [[ -n ${CI:-} ]]; then
  echo "checks: installing collections"
  ansible-galaxy collection install -r requirements.yml
fi

# Vault values are only decrypted at runtime, so no vault password is needed here.
echo "checks: syntax check"
ansible-playbook --syntax-check local.yml > /dev/null

echo "checks: ansible-lint"
ansible-lint

echo "checks: Renovate config validator"
npx --yes --package renovate@44.198.3 -- renovate-config-validator --strict renovate.json
