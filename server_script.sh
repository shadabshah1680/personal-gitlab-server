#!/bin/bash
URL=http://gitlab.example.com
sudo yum install -y curl policycoreutils openssh-server openssh-clients perl --allowerasing
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="$URL" yum install -y gitlab-ee