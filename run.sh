#!/bin/bash
# run.sh [tasks_file]

default_tasks="tasks/main.yml"
become_password_file="/tmp/ansible_become_password"
vault_password_file="/tmp/ansible_vault_password"
file="${1:-$default_tasks}"
file_path="$(readlink -f "$file")"
[ $# -gt 0 ] && shift 1

cd "${0%/*}" || exit
command -v ansible > /dev/null 2>&1 || ./scripts/bootstrap-ansible.sh

if [ ! -f "$become_password_file" -o ! -s "$become_password_file" ]; then
  read -rs -p 'become password: ' become_password
  echo
  printf '%s' "$become_password" > "$become_password_file"
fi

if [ ! -f "$vault_password_file" -o ! -s "$vault_password_file" ]; then
  read -rs -p 'vault password: ' vault_password
  echo
  printf '%s' "$vault_password" > "$vault_password_file"
fi

bin_dir="$HOME/.local/bin"
ansible-playbook -e "tasks_file='$file_path'" "$@" play.yml
