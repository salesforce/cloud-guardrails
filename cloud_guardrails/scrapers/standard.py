# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
from bs4 import BeautifulSoup
from cloud_guardrails.shared.utils import chomp_keep_single_spaces


def get_requirement_id(input_text: str, replacement_string: str) -> str:
    """Pass in table.previous_sibling.previous_sibling.text and get the Azure Benchmark ID"""
    id_ownership_string = chomp_keep_single_spaces(input_text)
    this_id = id_ownership_string
    this_id = this_id.replace(f"ID : {replacement_string} ", "")
    this_id = this_id.replace(f"ID : {replacement_string}", "")
    this_id = this_id.replace(" Ownership : Customer", "")
    this_id = this_id.replace(" Ownership : Shared", "")
    return this_id


def scrape_standard(html_file_path: str, benchmark_name: str, replacement_string: str):
    with open(html_file_path, "r") as f:
        soup = BeautifulSoup(f.read(), "html.parser")
    tables = soup.find_all("table")

    def get_service_name(github_link: str) -> str:
        """Pass in the github link and get the name of the service based on folder name"""
        elements = github_link.split("/")
        service_name = elements[-2:][0]
        service_name = service_name.replace("%20", " ")
        return service_name

    results = []
    categories = []
    for table in tables:
        table_identifier_sibling = table.previous_sibling.previous_sibling
        # Get requirement ID
        requirement_id = get_requirement_id(
            table_identifier_sibling.text, replacement_string
        )

        if replacement_string in table_identifier_sibling.text:
            # Requirement Name
            requirement_sibling = (
                table_identifier_sibling.previous_sibling.previous_sibling
            )
            requirement = chomp_keep_single_spaces(requirement_sibling.text)

            # Benchmark Category
            category_sibling = requirement_sibling.previous_sibling.previous_sibling
            if "(Azure portal)" not in chomp_keep_single_spaces(category_sibling.text):
                category = chomp_keep_single_spaces(category_sibling.text)
                categories.append(category)
            else:
                category = categories[-1]

            rows = table.find_all("tr")
            if len(rows) == 0:
                continue
            for row in rows:
                cells = row.find_all("td")
                if len(cells) == 0 or len(cells) == 1:
                    continue

                # Cell 0: Name with Azure Portal Link
                name_cell = cells[0]
                name_cell_href = cells[0].find_all("a", href=True)
                azure_portal_link = name_cell_href[0].attrs["href"]
                name_text = chomp_keep_single_spaces(name_cell.text)
                # Let's skip all the ones with Microsoft Managed Control; Azure be flexin', but that would unnecessarily
                # clutter our results since we are focusing on Customer/Shared responsibility only.
                if name_text.startswith("Microsoft Managed Control"):
                    continue
                policy_id = azure_portal_link.partition("policyDefinitions%2F")[2]

                # Cell 1: Description
                description_cell = cells[1]
                description = chomp_keep_single_spaces(cells[1].text)

                # Cell 2: Effects
                effects_cell = cells[2]
                effects = chomp_keep_single_spaces(cells[2].text)

                # Cell 3: The Version and the GitHub link
                github_link_cell = cells[3]
                github_link_cell_href = cells[3].find_all("a", href=True)
                github_link = github_link_cell_href[0].attrs["href"]
                github_version = chomp_keep_single_spaces(github_link_cell_href[0].text)
                service_name = get_service_name(github_link)

                entry = dict(
                    benchmark=benchmark_name,
                    category=category,
                    requirement=requirement,
                    requirement_id=requirement_id,
                    service_name=service_name,
                    name=name_text,
                    policy_id=policy_id,
                    description=description,
                    effects=effects,
                    github_link=github_link,
                    github_version=github_version,
                )
                results.append(entry)
        else:
            raise Exception("No benchmark ID found. Figure out how to handle this.")
    return results
