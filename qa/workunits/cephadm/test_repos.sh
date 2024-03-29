#!/bin/sh -ex

SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CEPHADM_SRC_DIR=${SCRIPT_DIR}/../../../src/cephadm
CEPHADM=${CEPHADM_SRC_DIR}/cephadm

# this is a pretty weak test, unfortunately, since the
# package may also be in the base OS.
function test_install_uninstall() {
    ( sudo apt -y install cephadm && \
	  sudo apt -y remove cephadm ) || \
	( sudo yum -y install cephadm && \
	      sudo yum -y remove cephadm ) || \
	( sudo dnf -y install cephadm && \
	      sudo dnf -y remove cephadm )
}

sudo $CEPHADM -v add-repo --release octopus
test_install_uninstall
sudo $CEPHADM -v rm-repo

sudo $CEPHADM -v add-repo --dev master
test_install_uninstall
sudo $CEPHADM -v rm-repo

sudo $CEPHADM -v add-repo --dev $CEPH_REF
test_install_uninstall
sudo $CEPHADM -v rm-repo

echo OK.
