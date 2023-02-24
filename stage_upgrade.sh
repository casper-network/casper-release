#!/usr/bin/env bash

set -e

# This script will stage the upgrade files for casper network from 1.4.8 to 1.4.9

if [ "$(whoami)" != "root" ]; then
  echo
  echo "Script must be run as root"
  echo "Do this with 'sudo $0'"
  echo
  exit 1
fi

if [[ -d "/etc/casper/1_4_9" ]]; then
   echo "Upgrade 1.4.9 already staged."
   exit 0
fi

CNL_VERSION=$(casper-node-launcher --version | cut -d' ' -f4)

# Format of the arguments to pull_casper_node_version.sh script changed to allow conf
# files for other networks with 0.3.3+.

if [ $CNL_VERSION == "0.3.2" ]; then
   echo "casper-node-launcher version 0.3.2, using old syntax."
   sudo -u casper /etc/casper/pull_casper_node_version.sh 1_4_9 casper
else
   echo "casper-node-launcher version 0.3.3+, using conf syntax."
   sudo -u casper /etc/casper/pull_casper_node_version.sh casper.conf 1_4_9
fi

sudo -u casper /etc/casper/config_from_example.sh 1_4_9
echo "Upgrade 1_4_9 staged."