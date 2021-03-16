import json
import os

COMPLIANCE_DATA_FILE = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__), os.path.pardir, "shared", "data", "compliance-data.json"
    )
)
with open(COMPLIANCE_DATA_FILE) as json_file:
    COMPLIANCE_DATA = json.load(json_file)


class BenchmarkEntryV2:
    def __init__(
        self, benchmark: str, category: str, requirement: str, requirement_id: str
    ):
        self.benchmark = benchmark
        self.category = category
        self.requirement = requirement
        self.requirement_id = requirement_id

    def __repr__(self):
        result = dict(
            benchmark=self.benchmark,
            category=self.category,
            requirement=self.requirement,
            requirement_id=self.requirement_id,
        )
        return json.dumps(result)

    def __str__(self):
        return json.dumps(self.__repr__())

    def json(self) -> dict:
        return json.loads(self.__repr__())


class ComplianceDataV2:
    def __init__(self, compliance_data_json: dict):
        self.compliance_data_json = compliance_data_json

    def _policy_definition_compliance_metadata(self):
        """Transforms the """
