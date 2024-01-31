#/bin/bash
User=zeki

## OS 정보 확인
OS=`cat /etc/*-release | grep PRETTY_NAME | awk '{print $1}' | cut -d "\"" -f2`

if [ $OS == "Rocky" ]; then
	OS_User=rocky
elif [ $OS == "Amazon" ]; then
	OS_User=ec2-user
elif [ $OS == "CentOS" ]; then
	OS_User=centos
else
	echo "설정되어있지 않은 OS입니다. 스크립트 종료!"
	exit 1
fi

## root 권한부여 유저 생성
useradd -G wheel $User

## New User pemkey copy
cp -arp /home/$OS_User/.ssh/ /home/$User/.ssh/

## copy key 권한 부여
chown $User.$User /home/$User/.ssh/
chown $User.$User /home/$User/.ssh/authorized_keys

## New User root 권한 획득
echo "$User ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
