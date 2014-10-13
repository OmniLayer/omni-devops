#!/bin/sh
# Build & install Omni AWS "dummy" base box
TMPDIR=tmp
export COPYFILE_DISABLE=1
mkdir -p $TMPDIR
tar cvzf $TMPDIR/omni-aws.box --exclude "._*" -C omni_aws_box ./metadata.json
vagrant box add --force --name omni-aws $TMPDIR/omni-aws.box
rm -rf $TMPDIR

