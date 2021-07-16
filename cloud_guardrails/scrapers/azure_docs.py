# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import requests
import os
import logging
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
