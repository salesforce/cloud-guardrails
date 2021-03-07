import os
import re
import csv
import logging
import click
import requests
import json
from bs4 import BeautifulSoup
import pandas as pd
from azure_guardrails.scrapers.azure_docs import get_azure_html, write_spreadsheets
from azure_guardrails.scrapers.cis_benchmark import scrape_cis

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
    results = scrape_cis(files[0])
    write_spreadsheets(results=results, results_path=destination)


if __name__ == '__main__':
    update_data()
