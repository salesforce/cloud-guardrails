import os
import re
import csv
import logging
import click
import requests
import json
from bs4 import BeautifulSoup
import pandas as pd
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
        # "azure_security_benchmark": "https://docs.microsoft.com/en-us/azure/governance/policy/samples/azure-security-benchmark",
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


def get_azure_html(link, file_path):
    file_name = os.path.basename(file_path)

    print(f"Getting the Azure documentation for: {file_name}")

    response = requests.get(link, allow_redirects=False)
    soup = BeautifulSoup(response.content, "html.parser")

    def cleanup_links():
        # Replace the CSS stuff. Basically this:
        """
        <link href='href="https://docs.aws.amazon.com/images/favicon.ico"' rel="icon" type="image/ico"/>

        """
        for link in soup.find_all("link"):
            if link.get("href").startswith("/"):
                temp = link.attrs["href"]
                link.attrs["href"] = link.attrs["href"].replace(
                    temp, f"https://docs.microsoft.com{temp}"
                )

        for script in soup.find_all("script"):
            try:
                if "src" in script.attrs:
                    if script.get("src").startswith("/"):
                        temp = script.attrs["src"]
                        script.attrs["src"] = script.attrs["src"].replace(
                            temp, f"https://docs.microsoft.com{temp}"
                        )
            except TypeError as t_e:
                logger.warning(t_e)
                logger.warning(script)
            except AttributeError as a_e:
                logger.warning(a_e)
                logger.warning(script)

    cleanup_links()

    if os.path.exists(file_path):
        print(f"Removing old file path: {file_path}")
        os.remove(file_path)
    with open(file_path, "w") as file:
        print(f"Creating new file: {os.path.abspath(file_path)}")
        file.write(str(soup.prettify()))
        file.close()
    logger.info("%s downloaded", file_name)
    return file_path


def chomp_keep_single_spaces(string):
    """This chomp cleans up all white-space, not just at the ends"""
    string = str(string)
    result = string.replace("\n", " ")  # Convert line ends to spaces
    result = re.sub(" [ ]*", " ", result)  # Truncate multiple spaces to single space
    result = result.replace(" ", " ")  # Replace weird spaces with regular spaces
    result = result.replace(u"\xa0", u" ")  # Remove non-breaking space
    result = re.sub("^[ ]*", "", result)  # Clean start
    return re.sub("[ ]*$", "", result)  # Clean end


def scrape_cis(html_file_path):
    results = []

    # url = "https://docs.microsoft.com/en-us/azure/governance/policy/samples/cis-azure-1-3-0"
    # page = requests.get(url)

    # soup = BeautifulSoup(page.text, "html.parser")
    with open(html_file_path, "r") as f:
        soup = BeautifulSoup(f.read(), "html.parser")
    h2 = soup.find_all("h2", class_="heading-anchor")
    h3 = soup.find_all("h3", class_="heading-anchor")
    tables = soup.find_all("table")

    def get_cis_id(input_text):
        """Pass in table.previous_sibling.previous_sibling.text and get the CIS ID"""
        id_ownership_string = chomp_keep_single_spaces(input_text)
        this_cis_id = id_ownership_string
        this_cis_id = this_cis_id.replace("ID : CIS Azure ", "")
        this_cis_id = this_cis_id.replace(" Ownership : Customer", "")
        return this_cis_id

    results = []
    for table in tables:
        # print(chomp_keep_single_spaces(table.text))
        # TODO: Get the header for this table because that is the CIS ID
        # Get the CIS Azure ID
        if "CIS Azure" in table.previous_sibling.previous_sibling.text:
            cis_id = get_cis_id(table.previous_sibling.previous_sibling.text)
            # print(cis_id)
        # print(chomp_keep_single_spaces(table.text))
            rows = table.find_all("tr")
            if len(rows) == 0:
                continue
            for row in rows:
                cells = row.find_all("td")
                if len(cells) == 0 or len(cells) == 1:
                    continue

                # Cell 0: Name with Azure Portal Link
                name_cell = cells[0]
                name_cell_href = cells[0].find_all('a', href=True)
                azure_portal_link = name_cell_href[0].attrs["href"]
                name_text = chomp_keep_single_spaces(name_cell.text)
                policy_id = azure_portal_link.partition("policyDefinitions%2F")[2]

                # Cell 1: Description
                description_cell = cells[1]
                description = chomp_keep_single_spaces(cells[1].text)

                # Cell 2: Effects
                effects_cell = cells[2]
                effects = chomp_keep_single_spaces(cells[2].text)

                # Cell 3: The Version and the GitHub link
                github_link_cell = cells[3]
                github_link_cell_href = cells[3].find_all('a', href=True)
                github_link = github_link_cell_href[0].attrs["href"]
                github_version = chomp_keep_single_spaces(github_link_cell_href[0].text)

                entry = dict(
                    cis_id=cis_id,
                    name=name_text,
                    policy_id=policy_id,
                    description=description,
                    effects=effects,
                    github_link=github_link,
                    github_version=github_version
                )
                results.append(entry)
        else:
            raise Exception("No CIS ID found. Figure out how to handle this.")
    return results


def write_spreadsheets(results: list, results_path: str):
    field_names = [
        "cis_id",
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
