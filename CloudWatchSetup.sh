#!/bin/bash

#VerifyingArguments

if [ $# -lt 2 ]; then
        echo 1>&2 "Command execute format: sudo bash CloudWatchSetup [access-key] [secret-key]"
        exit 2
elif [ $# -gt 2 ]; then
        echo 1>&2 "Number of arguments exceeded"
        exit 2
fi


base=$(cat /etc/os-release | grep ID_LIKE | cut -d '=' -f 2)
suse_base=$(cat /etc/os-release | grep -w ID | cut -d '=' -f 2)

#UbuntuServer
if [ "$base" == "debian" ]
	then
		dpkg -s python &> /dev/null
		if [ $? -eq 0 ]
			then
                                echo "Python is already installed. Downloading CloudWatch Deployment Script..."
				wget https://s3-us-west-2.amazonaws.com/akash-imgur/CloudWatchDeployment/UbuntuSetup.py
				python UbuntuSetup.py $1 $2
		else
				echo "Installing Python"
				apt-get update
				apt-get install -y python $1 $2
                                echo "Downloading CloudWatch Deployment Script..."
				wget https://s3-us-west-2.amazonaws.com/akash-imgur/CloudWatchDeployment/UbuntuSetup.py
                                python UbuntuSetup.py
		fi

#AmazonLinux
elif [ "$base" == '"rhel fedora"' ]
	then
		rpm -q python &> /dev/null
		if [ $? -eq 0 ]
			then
                                echo "Python is already installed. Downloading CloudWatch Deployment Script..."
				wget https://s3-us-west-2.amazonaws.com/akash-imgur/CloudWatchDeployment/AmazonLinuxSetup.py
				python AmazonLinuxSetup.py $1 $2
		else
				echo "Installing Python"
				yum -y install python
                                echo "Downloading CloudWatch Deployment Script..."
				wget https://s3-us-west-2.amazonaws.com/akash-imgur/CloudWatchDeployment/AmazonLinuxSetup.py
				python AmazonLinuxSetup.py $1 $2
		fi

#SUSELinux
elif [ "$suse_base" == '"sles"' ]
        then
                rpm -q python &> /dev/null
                if [ $? -eq 0 ]
                        then
                                echo "Python is already installed. Downloading CloudWatch Deployment Script..."
                                wget https://s3-us-west-2.amazonaws.com/akash-imgur/CloudWatchDeployment/SUSESetup.py
                                python SUSESetup.py $1 $2
                else
                                echo "Installing Python"
                                zypper -y install python
                                echo "Downloading CloudWatch Deployment Script..."
				wget https://s3-us-west-2.amazonaws.com/akash-imgur/CloudWatchDeployment/SUSESetup.py
                                python SUSESetup.py $1 $2
                fi
else
	echo "Distribution not supported"

fi

