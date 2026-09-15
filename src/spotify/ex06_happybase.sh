#!/bin/bash
# EX06 II & III (HappyBase) : memes operations en Python (Thrift port 9090)
set -e
python3 -c "import happybase; print('happybase', happybase.__version__)"
python3 /home/src/spotify/hbase/biblio_happybase.py
