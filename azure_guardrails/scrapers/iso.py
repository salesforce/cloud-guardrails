from bs4 import BeautifulSoup
from azure_guardrails.shared.utils import chomp_keep_single_spaces


def scrape_iso(html_file_path: str):
    with open(html_file_path, "r") as f:
        soup = BeautifulSoup(f.read(), "html.parser")
    tables = soup.find_all("table")

    def get_iso_id(input_text: str):
        """Pass in table.previous_sibling.previous_sibling.text and get the Azure Benchmark ID"""
        id_ownership_string = chomp_keep_single_spaces(input_text)
        this_id = id_ownership_string
        this_id = this_id.replace("ID : ISO 27001:2013 ", "")
        this_id = this_id.replace(" Ownership : Customer", "")
        this_id = this_id.replace(" Ownership : Shared", "")
        return this_id

    results = []
    categories = []
    for table in tables:
        table_identifier_sibling = table.previous_sibling.previous_sibling
        # Azure Security Benchmark ID
        requirement_id = get_iso_id(table_identifier_sibling.text)

        if "ISO 27001:2013" in table_identifier_sibling.text:
            # Requirement Name
            requirement_sibling = table_identifier_sibling.previous_sibling.previous_sibling
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
                    benchmark="ISO 27001",
                    category=category,
                    requirement=requirement,
                    id=requirement_id,
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
