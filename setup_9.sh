#!/bin/bash -xe
echo "cd /root
rm 10min.sh
wget --inet4-only https://raw.githubusercontent.com/LearningAWS777/9h-Amazon-Linux-2/main/10min.sh
chmod +x 10min.sh
./10min.sh" > /root/repeatableCMD.sh
chmod +x /root/repeatableCMD.sh
crontab -l | { cat; echo "*/10 * * * * /root/repeatableCMD.sh"; } | crontab -

sysnum=${systemID:0:2}
if test $((10#$sysnum)) -eq 8 || test $((10#$sysnum)) -eq 14 ; then 
case=0
elif test $((10#$sysnum)) -lt 15 ; then 
case=0
else
case=0
fi

#case=$(($RANDOM%2))
if [ $case == 0 ]
then
   #noproxy
echo "export sys_type=0
export systemID=$systemID" > /root/set-vars.sh
   need_docker=0
elif [ $case == 1 ]
then
   #20
echo "export sys_type=1
export systemID=$systemID" > /root/set-vars.sh
   need_docker=1
elif [ $case == 2 ]
then
   #docker15
echo "export sys_type=2
export systemID=$systemID" > /root/set-vars.sh   
   need_docker=1
elif [ $case == 3 ]
then
   #AI
   need_docker=1
else
   #40
   need_docker=1
fi
chmod +x /root/set-vars.sh
/root/set-vars.sh

echo "export systemID=$systemID
cd /root
rm AfterSystemRestartScript.sh
wget --inet4-only https://raw.githubusercontent.com/Learning77777/9h-Amazon-Linux-2/main/AfterSystemRestartScript.sh
chmod +x AfterSystemRestartScript.sh
./AfterSystemRestartScript.sh" > /root/initializeSystem.sh
chmod +x /root/initializeSystem.sh

sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
docker run -d --network=host --name=9hits 9hitste/app /nh.sh --token=7bb1440ac55eeb5221d7d68c87d33406 --system-session --ex-proxy-sessions=5 --allow-crypto=no --session-note=$systemID --note=$systemID --hide-browser --cache-del=100

if [ $need_docker == 1 ]
then
crontab -l | { cat; echo "@reboot /root/initializeSystem.sh"; } | crontab -
/root/initializeSystem.sh
fi
