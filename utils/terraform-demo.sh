#!/usr/bin/env bash
set -x

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

#### Generate the example Terraform files
# No Parameters
export no_params_folder="examples/terraform-demo-no-params"
cloud-guardrails generate-terraform --no-params \
  --service all \
  --subscription example \
  --no-summary  > ${no_params_folder}/main.tf

# Optional Parameters
export params_optional_folder="examples/terraform-demo-params-optional"
cloud-guardrails generate-terraform --params-optional \
  --service all \
  --subscription example \
  --no-summary  > ${params_optional_folder}/main.tf

# Required Parameters
export params_required_folder="examples/terraform-demo-params-required"
cloud-guardrails generate-terraform --params-required \
  --service all \
  --subscription example \
  --no-summary  > ${params_required_folder}/main.tf

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
