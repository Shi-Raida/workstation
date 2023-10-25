#!/bin/sh

opt_dir="/usr/local/opt"
bin_dir="/usr/local/bin"

dpkg -s python3-venv > /dev/null 2>&1 || apt install -y python3-venv
python3 -m venv "$opt_dir/ansible"
. "$opt_dir/ansible/bin/activate" || exit
pip install ansible
ln -s "$opt_dir/ansible/bin/ansible"* "$bin_dir/"
