#!/bin/sh
# © Copyright 2019-2020, Cray Inc.
set -x

RECIPE_ROOT_PARENT=${1:-/mnt/recipe}
IMAGE_ROOT_PARENT=${2:-/mnt/image}
PARAMETER_FILE_BUILD_FAILED=$IMAGE_ROOT_PARENT/build_failed

export PACKER_LOG=True
export PACKER_LOG_PATH=$IMAGE_ROOT_PARENT/packer.log

# Make Cray's CA certificate a trusted system certificate within the container
# This will not install the CA certificate into the packer imageroot.
CA_CERT='/etc/cray/ca/certificate_authority.crt'
if [[ -e $CA_CERT ]]; then
	cp $CA_CERT  /usr/share/pki/trust/anchors/.
else
	echo "The CA certificate file: $CA_CERT is missing"
	exit 1
fi
update-ca-certificates
RC=$?
if [[ ! $RC ]]; then
	echo "update-ca-certificates exited with return code: $RC "
	exit 1
fi

python -m ims_python_helper image set_job_status $IMS_JOB_ID building_image

DEBUG_FLAGS=""
if [[ `echo $ENABLE_DEBUG | tr [:upper:] [:lower:]` = "true" ]]; then
    DEBUG_FLAGS="-debug"
fi

mkdir -p $IMAGE_ROOT_PARENT/build/image
cd $IMAGE_ROOT_PARENT/build/image

# Call packer to build the image recipe.
/usr/local/packer build $DEBUG_FLAGS -machine-readable -color=false $RECIPE_ROOT_PARENT/template.json
rc=$?

if [ "$rc" -ne "0" ]; then
  echo "ERROR: Packer reported a build error."
  touch $PARAMETER_FILE_BUILD_FAILED
fi

# Always return 0
exit 0
