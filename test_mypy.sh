#!/bin/bash
set -e
serverIp=159.89.154.87
git clone https://github.com/snsnlou2/mypy.git
cd mypy
git checkout release-0.800
git submodule init
git submodule update
cd ..
pip install -U ./mypy
pip install astunparse
rm -rf ./mypy
python3 typecheck.py
eval "$(ssh-agent -s)"
chmod 600 root_key
ssh-keyscan $serverIp >> ~/.ssh/known_hosts
ssh-add root_key
zip -r mypy_test_cache.zip mypy_test_cache/
owner=scrapy
repo=scrapy-Pair3-before
pv=$(python3 -V | cut -c8-10)
arc=$(uname -m)
yes | scp -i root_key ./mypy_test_cache.zip "root@$serverIp:~/cache/$owner---$repo\($pv---$arc\).zip"
yes | scp -i root_key ./mypy_test_report.txt "root@$serverIp:~/report/$owner---$repo\($pv---$arc\).txt"
yes | scp -i root_key ./reveal_locals_location.csv "root@$serverIp:~/reveal_locals/$owner---$repo\($pv---$arc\).csv"
