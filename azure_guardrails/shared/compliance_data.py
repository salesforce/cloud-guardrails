from typing import Dict
import os
import json

COMPLIANCE_DATA_FILE = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "data",
    "results.json"
))
with open(COMPLIANCE_DATA_FILE) as json_file:
    COMPLIANCE_DATA = json.load(json_file)


class BenchmarkEntry:
    def __init__(self, benchmark: str, category: str, requirement: str, requirement_id: str):
        self.benchmark = benchmark
        self.category = category
        self.requirement = requirement
        self.requirement_id = requirement_id

    def __repr__(self) -> dict:
        result = dict(
            benchmark=self.benchmark,
            category=self.category,
            requirement=self.requirement,
            requirement_id=self.requirement_id,
        )
        return result

    def json(self) -> dict:
        return self.__repr__()


class PolicyDefinitionMetadata:
    def __init__(self, policy_id: str, service_name: str, effects: str, description: str, name: str, benchmark: str, category: str, requirement: str, requirement_id: str):
        self.policy_id = policy_id
        self.service_name = service_name
        self.effects = effects
        self.description = description
        self.name = name
        self.benchmarks = self._benchmarks(benchmark=benchmark, requirement=requirement, requirement_id=requirement_id, category=category)

    def __repr__(self) -> dict:
        benchmark_response = {}
        for benchmark in self.benchmarks:
            benchmark_response[benchmark.benchmark] = benchmark.json()
        result = dict(
            policy_id=self.policy_id,
            effects=self.effects,
            description=self.description,
            name=self.name,
            service_name=self.service_name,
            benchmarks=benchmark_response,
        )
        return result

    def json(self) -> dict:
        return self.__repr__()

    def _benchmarks(self, benchmark: str, category: str, requirement: str, requirement_id: str) -> [BenchmarkEntry]:
        result = []
        benchmark_entry = BenchmarkEntry(benchmark=benchmark, category=category, requirement=requirement, requirement_id=requirement_id)
        result.append(benchmark_entry)
        return result

    def get_compliance_data_matching_policy_definition(self) -> dict:
        result = {}
        for benchmark in self.benchmarks:
            benchmark_name = benchmark.benchmark
            benchmark_string = f"{benchmark.benchmark}: {benchmark.requirement_id} ({benchmark.requirement})"
            result[benchmark_name] = benchmark_string
        return result


class ComplianceResultsTransformer:
    """
    Transforms the metadata generated from scraping into the JSON format that is friendlier for our analysis.

    See the ComplianceData class to actually use this data.
    """
    def __init__(self, results_list: list):
        self.results_list_json = results_list
        self.results = self._results()

    def __repr__(self) -> dict:
        response = {}
        for result_key, result_value in self.results.items():
            response[result_key] = result_value.json()
        return response

    def json(self) -> dict:
        return self.__repr__()

    def _results(self) -> {PolicyDefinitionMetadata}:
        results = {}
        for result in self.results_list_json:
            if result.get("name") not in results.keys():
                policy_definition_metadata = PolicyDefinitionMetadata(
                    policy_id=result.get("policy_id"),
                    service_name=result.get("service_name"),
                    effects=result.get("effects"),
                    description=result.get("description"),
                    name=result.get("name"),
                    benchmark=result.get("benchmark"),
                    category=result.get("category"),
                    requirement=result.get("requirement"),
                    requirement_id=result.get("requirement_id"),
                )
                results[result.get("name")] = policy_definition_metadata
            else:
                benchmark = result.get("benchmark")
                category = result.get("category")
                requirement = result.get("requirement")
                requirement_id = result.get("requirement_id")
                benchmark_entry = BenchmarkEntry(benchmark=benchmark, category=category, requirement=requirement,
                                                 requirement_id=requirement_id)
                results[result.get("name")].benchmarks.append(benchmark_entry)
        return results


class PolicyComplianceData:
    def __init__(self):
        self.compliance_data = COMPLIANCE_DATA
        self.policy_definition_metadata = self._policy_definition_metadata()

    def __repr__(self):
        return COMPLIANCE_DATA

    def __str__(self):
        return json.dumps(COMPLIANCE_DATA)

    def json(self):
        return COMPLIANCE_DATA

    def _policy_definition_metadata(self) -> {PolicyDefinitionMetadata}:
        results = {}
        for metadata_key, metadata_values in self.compliance_data.items():
            name = metadata_values.get("name")
            policy_id = metadata_values.get("policy_id")
            service_name = metadata_values.get("service_name")
            effects = metadata_values.get("effects")
            description = metadata_values.get("description")
            for benchmark_key, benchmark_values in metadata_values.get("benchmarks").items():
                benchmark = benchmark_key
                category = benchmark_values.get("category")
                requirement = benchmark_values.get("requirement")
                requirement_id = benchmark_values.get("requirement_id")
                policy_definition_metadata = PolicyDefinitionMetadata(
                    policy_id=policy_id,
                    service_name=service_name,
                    effects=effects,
                    description=description,
                    name=name,
                    benchmark=benchmark,
                    category=category,
                    requirement=requirement,
                    requirement_id=requirement_id,
                )
                results[name] = policy_definition_metadata
        return results

    def policy_definition_names(self):
        result = list(self.policy_definition_metadata.keys())
        result.sort()
        return result

    def get_compliance_data_matching_policy_definition(self, policy_definition_name) -> dict:
        metadata = self.policy_definition_metadata.get(policy_definition_name)
        result = metadata.get_compliance_data_matching_policy_definition()
        return result
