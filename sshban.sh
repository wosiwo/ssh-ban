#! /bin/bash
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /root/worker/black.txt
DEFINE="5"
for i in `cat  /root/worker/black.txt`
do
    IP=`echo $i|awk -F= '{print $1}'`
    NUM=`echo $i|awk -F= '{print $2}'`
    if [ $NUM -gt $DEFINE ]
    then
                IGNORE_BAN=$( grep -c $IP /etc/hosts.deny)

        if [ $IGNORE_BAN -gt 0 ];then
          continue
        fi
        echo "sshd:$IP:deny" >> /etc/hosts.deny
    fi
done


