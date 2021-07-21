#!/usr/bin/env bash
set -x

SUBSCRIPTION_NAME="${SUBSCRIPTION_NAME:=example}"
FOLDER="${FOLDER:=examples}"

# Validate that cloud-guardrails tool is installed
if ! command -v cloud-guardrails &> /dev/null
then
    echo "cloud-guardrails could not be found. Please download and install the tool from https://github.com/salesforce/cloud-guardrails/"
    exit
fi

# Validate that Terraform 0.12 is installed and in use
is_tf_version_12=$(terraform version | grep -m1 "" | grep -m1 "0\.12\.");

if [[ -z $is_tf_version_12 ]]; then
  echo "Terraform 0.12.x is NOT used. Let's try to install it with tfenv";
  # If tfenv is not installed
  if ! command -v tfenv &> /dev/null
  then
      echo "tfenv could not be found. Please download and install the tool from https://github.com/tfutils/tfenv"
      exit
  fi
  # If tfenv exists, install Terraform 0.12.x
  tfenv install 0.12.28
  tfenv use 0.12.28
else
  echo "Terraform 0.12.x is used. We can leverage that for running terraform validate";
fi

if ! command -v cloud-guardrails &> /dev/null
then
    echo "cloud-guardrails could not be found. Please download and install the tool from https://github.com/salesforce/cloud-guardrails/"
    exit
fi

# Create Folders
export no_params_folder="${FOLDER}/terraform-demo-no-params"
mkdir -p no_params_folder
export params_optional_folder="${FOLDER}/terraform-demo-params-optional"
mkdir -p params_optional_folder
export params_required_folder="${FOLDER}/terraform-demo-params-required"
mkdir -p params_required_folder


#### Generate the example Terraform files
# No Parameters
cloud-guardrails generate-terraform --no-params \
  --service all \
  --subscription ${SUBSCRIPTION_NAME} \
  --no-summary --output ${no_params_folder}

# Optional Parameters
cloud-guardrails generate-terraform --params-optional \
  --service all \
  --subscription ${SUBSCRIPTION_NAME} \
  --no-summary --output ${params_optional_folder}

# Required Parameters
cloud-guardrails generate-terraform --params-required \
  --service all \
  --subscription ${SUBSCRIPTION_NAME} \
  --no-summary --output ${params_required_folder}

# Run Terraform validate inside there
echo "Running Terraform validate"
pwd
declare -a dirs=( ${no_params_folder} ${params_optional_folder} ${params_required_folder} )

for dir in ${dirs[@]}; do
  cd ./$dir/
  echo "Running terraform validate in $${dir}..";
  terraform init -backend=false
  terraform validate
  echo $!
  cd ../../
done
