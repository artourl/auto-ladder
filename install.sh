#/bin/bash

apt-get update

fd="/usr/lib/systemd/system"
if [ ! -d "$fd" ]; then
  mkdir "$fd"
fi

systemctl stop ssserver.service >/dev/null 2>&1
systemctl stop kcptun-server.service >/dev/null 2>&1

echo "environment guaranteed"

# shadowsocks

if command -v pip >/dev/null; then
  echo "pip exists"
else
  apt install python-pip >/dev/null
  echo "pip installed"
fi


if command -v ssserver >/dev/null; then
  echo "shadowsocks exists"
else
  pip install git+https://github.com/shadowsocks/shadowsocks.git@master
  echo "shadowsocks installed"
fi

cp ./json/shadowsocks.json /etc/shadowsocks.json
cp ./service/ssserver.service /usr/lib/systemd/system/
echo "shadowsocks config, service copied"

systemctl enable ssserver.service
systemctl start ssserver.service

# kcptun
kcptun_gz="kcptun-linux-amd64-20190611.tar.gz"
if [ ! -f "$kcptun_gz" ]; then
  wget https://github.com/xtaci/kcptun/releases/download/v20190611/kcptun-linux-amd64-20190611.tar.gz >/dev/null
fi

kcptun_fd="kcptun"
if [ ! -d "$kcptun_fd" ]; then
  mkdir "$kcptun_fd"
fi

tar -xvf kcptun-linux-amd64-20190611.tar.gz -C kcptun >/dev/null
cp ./kcptun/server_linux_amd64 /usr/local/bin/
echo "kcptun installed"
cp ./json/kcptun.json /etc/kcptun.json
cp ./service/kcptun-server.service /usr/lib/systemd/system/
echo "kcptun config, service copied"
systemctl enable kcptun-server.service
systemctl start kcptun-server.service

# check
# systemctl status ssserver.service
# systemctl status kcptun-server.service
if systemctl status ssserver.service | grep active >/dev/null; then
  echo "ssserver on"
fi
if systemctl status kcptun-server.service | grep active >/dev/null; then
  echo "kcptun-server on"
fi

