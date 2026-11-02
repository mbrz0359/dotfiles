# Complete `ansible-playbook -e` with the values listed in ./.ansible-extra-vars (one per line).
_ansible_playbook_extra_vars() {
  if [[ $words[CURRENT-1] == (-e|--extra-vars) && -r .ansible-extra-vars ]]; then
    local -a vars=(${(f)"$(<.ansible-extra-vars)"})
    compadd -a vars
  else
    _ansible "$@"
  fi
}
compdef _ansible_playbook_extra_vars ansible-playbook
