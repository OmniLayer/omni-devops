#!/bin/sh
# Build & install Omni AWS "dummy" base box
# assumes a subdirectory named 'omni_aws_box' is in the same directory as this script.
# creates ${SCRIPTDIR}/omni-aws.box which can be checked in to Git.
set -x -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BOXSUBDIR="${SCRIPTDIR}/omni_aws_box_src"
export COPYFILE_DISABLE=1
tar cvzf "${SCRIPTDIR}/omni-aws.box" --exclude "._*" -C "${BOXSUBDIR}" ./metadata.json
vagrant box add --force --name omni-aws "${SCRIPTDIR}/omni-aws.box"

