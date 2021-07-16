#!/usr/bin/env bash
set -x

cloud-guardrails --help

# Run generate-terraform for all 3 types
cloud-guardrails generate-terraform --service all --subscription example --no-params
cloud-guardrails generate-terraform --service all --subscription example --params-optional
cloud-guardrails generate-terraform --service all --subscription example --params-required

# Copy files to the docs directory
mv NP-all-table.csv docs/summaries/no-params.csv
mv NP-all-table.md docs/summaries/no-params.md
mv PO-all-table.csv docs/summaries/params-optional.csv
mv PO-all-table.md docs/summaries/params-optional.md
mv PR-all-table.csv docs/summaries/params-required.csv
mv PR-all-table.md docs/summaries/params-required.md

rm no_params.tf
rm params_optional.tf
rm params_required.tf

python3 ./utils/combine_csvs.py
