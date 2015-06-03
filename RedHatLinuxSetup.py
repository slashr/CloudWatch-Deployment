import subprocess, os, sys

access_key = sys.argv[1]
secret_key = sys.argv[2]
path = ""

def install_dependencies():
	subprocess.call(["yum", "-y", "install", "perl-core"])
	subprocess.call(["yum", "-y", "install", "perl-DateTime"])
	subprocess.call(["yum", "-y", "install", "perl-Sys-Syslog"])
	subprocess.call(["yum", "-y", "install", "unzip"])

def setup_cloudwatch():
        subprocess.call(["wget", "http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip"])
	subprocess.call(["unzip", "CloudWatchMonitoringScripts-1.2.1.zip"])
	subprocess.call(["rm", "CloudWatchMonitoringScripts-1.2.1.zip"])
	subprocess.call(["mkdir", "/opt/cloudwatch"])
	subprocess.call(["mv", "aws-scripts-mon", "/opt/cloudwatch/"])
	os.chdir("/opt/cloudwatch/aws-scripts-mon")
	global path
	path = os.getcwd()+"/awscreds.template"
	subprocess.call("echo AWSAccessKeyId='%s' > awscreds.template" %access_key, shell=True)
	subprocess.call("echo AWSSecretKey='%s' >> awscreds.template" %secret_key, shell=True)		

def put_metrics():
	subprocess.call("./mon-put-instance-data.pl --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-path=/ --disk-space-util --disk-space-used --disk-space-avail --aws-credential-file='%s'" %path, shell=True)
	subprocess.call("crontab -l | { cat; echo '*/5 * * * * /opt/cloudwatch/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-path=/ --disk-space-util --disk-space-used --disk-space-avail --aws-credential-file='%s''; } | crontab -" %path, shell=True)

install_dependencies()	
setup_cloudwatch()
put_metrics()

