#!/bin/sh

opt_dir="$HOME/.local/opt"
bin_dir="$HOME/.local/bin"
mkdir -p "$opt_dir"
mkdir -p "$bin_dir"

dpkg -s python3-venv > /dev/null 2>&1 || sudo apt install -y python3-venv
python3 -m venv "$opt_dir/ansible"
# shellcheck disable=SC1091
. "$opt_dir/ansible/bin/activate" || exit
pip install ansible ansible-lint
ln -s "$opt_dir/ansible/bin/ansible"* "$bin_dir/"
