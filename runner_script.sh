#!/bin/bash
URL=http://gitlab.example.com
TOKEN=D8wPuXvJuSCy4xVaz6h9
sudo yum install git docker -y
sudo systemctl start docker 
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_aarch64.rpm"
sudo rpm -i gitlab-runner_aarch64.rpm
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