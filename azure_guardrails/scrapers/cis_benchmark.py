from bs4 import BeautifulSoup
from azure_guardrails.shared.utils import chomp_keep_single_spaces


def scrape_cis(html_file_path: str):
    with open(html_file_path, "r") as f:
        soup = BeautifulSoup(f.read(), "html.parser")
    tables = soup.find_all("table")

    def get_cis_id(input_text: str):
        """Pass in table.previous_sibling.previous_sibling.text and get the CIS ID"""
        id_ownership_string = chomp_keep_single_spaces(input_text)
        this_id = id_ownership_string
        this_id = this_id.replace("ID : CIS Azure ", "")
        this_id = this_id.replace(" Ownership : Customer", "")
        return this_id

    results = []
    categories = []
    for table in tables:
        # Get the CIS Azure ID
        cis_identifier_sibling = table.previous_sibling.previous_sibling
        if "CIS Azure" in cis_identifier_sibling.text:
            # CIS Benchmark ID
            cis_id = get_cis_id(cis_identifier_sibling.text)

            # CIS Requirement Name
            cis_requirement_sibling = cis_identifier_sibling.previous_sibling.previous_sibling
            cis_requirement = chomp_keep_single_spaces(cis_requirement_sibling.text)

            # CIS Benchmark Category
            cis_category_sibling = cis_requirement_sibling.previous_sibling.previous_sibling
            if "(Azure portal)" not in chomp_keep_single_spaces(cis_category_sibling.text):
                cis_category = chomp_keep_single_spaces(cis_category_sibling.text)
                categories.append(cis_category)
            else:
                cis_category = categories[-1]

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
                    benchmark="CIS",
                    category=cis_category,
                    requirement=cis_requirement,
                    id=cis_id,
                    name=name_text,
                    policy_id=policy_id,
                    description=description,
                    effects=effects,
                    github_link=github_link,
                    github_version=github_version
                )
                results.append(entry)
        else:
            raise Exception("No benchmark ID found. Figure out how to handle this.")
    return results

