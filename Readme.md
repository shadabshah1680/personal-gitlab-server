## Requirements
- `AMI` : al2022-ami-minimal-2022.0.20220817.0-kernel-5.15-arm64
- `AMI Specs` : Must not less than `t4g.medium`
## Setting Up Server
Server Script:
``` bash
URL=http://gitlab.example.com
sudo yum install -y curl policycoreutils openssh-server openssh-clients perl --allowerasing
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="$URL" yum install -y gitlab-ee
```
- >> `Note`: Please be patience for at least 10 minutes during server installation
- >> `Note`: Please don't forget to set A type record against server public ip using same URL
- >> `Note`: For accessing gitlab-server use $URL in browser  with deafult username as root and find password using following command in gitlab-server
```
 sudo cat /etc/gitlab/initial_root_password  | grep -i Password:
```
## Setting Up Runner
Runner Script:
``` bash
ARCH=$(uname -m)
URL=http://gitlab.example.com
TOKEN=D8wPuXvJuSCy4xVaz6h9
sudo yum install git docker -y
sudo systemctl start docker 
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_$ARCH.rpm"
sudo rpm -i gitlab-runner_$ARCH.rpm
cat >/etc/gitlab-runner/config.toml<< EOF
concurrent = 1
check_interval = 0
shutdown_timeout = 0
[session_server]
  session_timeout = 1800
[[runners]]
  name = "docker"
  url = "$URL"
  id = 1
  token = "$TOKEN"
  token_obtained_at = 2023-03-21T16:26:47Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "docker"
  [runners.cache]
    MaxUploadedArchiveSize = 0
  [runners.docker]
    tls_verify = false
    image = "ruby:2.7"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
EOF
sudo gitlab-runner restart
```
