#/bin/bash
## AWS EC2 생성시 기본계정이 아닌 새로 만든 계정으로 접근하게 하기 위한 스크립트.
## 사용 가능한 OS ( AmazonLinux2, Rocky, Centos )

## 사용할 User 기입 
## ex) User=Harulife
User=test

## OS 정보 확인 및 OS별 기본 User 설정
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

## wheel 그룹에 신규 유저 추가
useradd -G wheel $User

## 신규 유저 디렉토리에 Key파일 복사
cp -arp /home/$OS_User/.ssh/ /home/$User/.ssh/

## 복사한 Key 파일에 소유권 변경
chown $User.$User /home/$User/.ssh/
chown $User.$User /home/$User/.ssh/authorized_keys

## 새로 만든 계정이 sudo 권한얻을때 패스워드 질의 x 처리
echo "$User ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
