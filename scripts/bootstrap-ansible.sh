#!/bin/sh

opt_dir="$HOME/.local/opt"
bin_dir="$HOME/.local/bin"

dpkg -s python3-venv > /dev/null 2>&1 || sudo apt install -y python3-venv
python3 -m venv "$opt_dir/ansible"
. "$opt_dir/ansible/bin/activate" || exit
pip install ansible
ln -s "$opt_dir/ansible/bin/ansible"* "$bin_dir/"
