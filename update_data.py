import os
import sys
import json
from pathlib import Path
import csv
import logging
import click
import pandas as pd
from typing import Dict
from azure_guardrails.scrapers.azure_docs import get_azure_html
from azure_guardrails.scrapers.standard import scrape_standard
from azure_guardrails.scrapers.compliance_data import ComplianceResults

logger = logging.getLogger(__name__)  # pylint: disable=invalid-name


@click.command(
    short_help='Update the Azure compliance data.'
)
@click.option(
    '--dest',
    "-d",
    "destination",
    required=True,
    type=click.Path(exists=True),
    help='Destination folder to store the docs'
)
@click.option(
    "--download",
    is_flag=True,
    default=False,
    help="Download the compliance files again, potentially overwriting the ones that already exist.",
)
def update_data(destination, download):
    links = {
        "cis_benchmark": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/cis-azure-1-3-0",
        "azure_security_benchmark": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/azure-security-benchmark",
        "ccmc-l3": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/cmmc-l3",
        "hipaa-hitrust-9-2": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/hipaa-hitrust-9-2",
        "iso-27007": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/iso-27001",
        "new-zealand-ism": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/new-zealand-ism",
        "nist-sp-800-53-r4": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/nist-sp-800-53-r4",
        "nist-sp-800-171-r2": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/nist-sp-800-171-r2",
    }
    files = []
    destination = os.path.abspath(destination)
    print(destination)
    # Get the file names
    for standard, link in links.items():
        filename = os.path.join(destination, f"{standard}.html")
        files.append(filename)

    # Download the docs
    if download:
        for standard, link in links.items():
            file = get_azure_html(link, os.path.join(destination, f"{standard}.html"))
    else:
        print("Download not selected; files must already exist.")

    print(files)
    results = []

    cis_result = scrape_standard(files[0], replacement_string="CIS Azure", benchmark_name="CIS")
    results.extend(cis_result)
    azure_benchmark_results = scrape_standard(files[1], replacement_string="Azure Security Benchmark", benchmark_name="Azure Security Benchmark")
    results.extend(azure_benchmark_results)
    cmmc_l3_results = scrape_standard(files[2], replacement_string="CMMC L3", benchmark_name="CMMC L3")
    results.extend(cmmc_l3_results)
    hipaa_hitrust_results = scrape_standard(files[3], replacement_string="", benchmark_name="HIPAA HITRUST 9.2")
    results.extend(hipaa_hitrust_results)
    iso_results = scrape_standard(files[4], replacement_string="ISO 27001:2013", benchmark_name="ISO 27001")
    results.extend(iso_results)
    new_zealand_results = scrape_standard(files[5], replacement_string="NZISM Security Benchmark", benchmark_name="NZISM Security Benchmark")
    results.extend(new_zealand_results)
    nist_800_53_results = scrape_standard(files[6], replacement_string="NIST SP 800-53 R4", benchmark_name="NIST SP 800-53 R4")
    results.extend(nist_800_53_results)
    nist_800_171_results = scrape_standard(files[7], replacement_string="NIST SP 800-171 R2", benchmark_name="NIST SP 800-171 R2")
    results.extend(nist_800_171_results)

    write_spreadsheets(results=results, results_path=destination)
    # dump the raw results

    # raw_json_results_path = os.path.join(destination, "raw_results.json")
    # with open(raw_json_results_path, "w") as file:
    #     json.dump(results, file, indent=4)
    # print(f"Saved raw json results to {raw_json_results_path}")
    compliance_results = ComplianceResults(results_list=results)
    raw_json_results_path = os.path.join(destination, "results.json")
    with open(raw_json_results_path, "w") as file:
        json.dump(compliance_results.json(), file, indent=4)
    print(f"Saved json results to {raw_json_results_path}")


def write_spreadsheets(results: list, results_path: str):
    field_names = [
        "benchmark",
        "category",
        "requirement",
        "requirement_id",
        "service_name",
        "name",
        "policy_id",
        "description",
        "effects",
        "github_link",
        "github_version",
    ]
    csv_file_path = os.path.join(results_path, "results.csv")
    with open(csv_file_path, 'w', newline='') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=field_names)
        writer.writeheader()
        for row in results:
            writer.writerow(row)
    print(f"CSV updated! Wrote {len(results)} rows. Path: {csv_file_path}")

    df_new = pd.read_csv(csv_file_path)
    excel_file_path = os.path.join(results_path, "results.xlsx")
    writer = pd.ExcelWriter(excel_file_path)
    df_new.to_excel(writer, index=False)
    writer.save()
    print(f"Excel file updated! Wrote {len(results)} rows. Path: {excel_file_path}")


if __name__ == '__main__':
    update_data()
