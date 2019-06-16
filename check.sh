#!bin/bash

if systemctl status ssserver.service | grep active >/dev/null; then
  echo "ssserver on"
fi
if systemctl status kcptun-server.service | grep active >/dev/null; then
  echo "kcptun-server on"
fi
