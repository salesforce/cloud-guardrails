import requests
import os
import csv
import logging
import pandas as pd
from bs4 import BeautifulSoup
logger = logging.getLogger(__name__)  # pylint: disable=invalid-name


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


def write_spreadsheets(results: list, results_path: str):
    field_names = [
        "cis_category",
        "cis_requirement",
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

