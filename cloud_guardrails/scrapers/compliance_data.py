# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import json


class BenchmarkEntry:
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


class PolicyDefinitionMetadata:
    def __init__(
        self,
        policy_id: str,
        service_name: str,
        effects: str,
        description: str,
        name: str,
        benchmark: str,
        category: str,
        requirement: str,
        requirement_id: str,
        github_link: str,
        github_version: str,
    ):
        self.policy_id = policy_id
        self.service_name = service_name
        self.effects = effects
        self.description = description
        self.name = name
        self.github_link = github_link
        self.github_version = github_version
        self.benchmarks = self._benchmarks(
            benchmark=benchmark,
            requirement=requirement,
            requirement_id=requirement_id,
            category=category,
        )

    def __repr__(self) -> str:
        benchmark_response = {}
        for benchmark, benchmark_value in self.benchmarks.items():
            benchmark_response[benchmark_value.benchmark] = benchmark_value.json()
        result = dict(
            policy_id=self.policy_id,
            effects=self.effects,
            description=self.description,
            name=self.name,
            service_name=self.service_name,
            github_link=self.github_link,
            github_version=self.github_version,
            benchmarks=benchmark_response,
        )
        return json.dumps(result)

    def __str__(self):
        return self.__repr__()

    def json(self) -> dict:
        return json.loads(self.__repr__())

    def _benchmarks(
        self, benchmark: str, category: str, requirement: str, requirement_id: str
    ) -> {BenchmarkEntry}:
        result = {}
        benchmark_entry = BenchmarkEntry(
            benchmark=benchmark,
            category=category,
            requirement=requirement,
            requirement_id=requirement_id,
        )
        result[benchmark] = benchmark_entry
        return result

    def get_compliance_data_matching_policy_definition(self) -> dict:
        result = {}
        for benchmark, benchmark_value in self.benchmarks.items():
            benchmark_name = benchmark_value.benchmark
            benchmark_string = (
                f"{benchmark_value.benchmark}: {benchmark_value.requirement_id}"
            )
            # benchmark_string = f"{benchmark_value.benchmark}: {benchmark_value.requirement_id} ({benchmark_value.requirement})"
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

    def __repr__(self) -> str:
        response = {}
        for result_key, result_value in self.results.items():
            response[result_key] = result_value.json()
        return json.dumps(response)

    def json(self) -> dict:
        return json.loads(self.__repr__())

    def __str__(self):
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
                    github_link=result.get("github_link"),
                    github_version=result.get("github_version"),
                )
                results[result.get("name")] = policy_definition_metadata
            else:
                benchmark = result.get("benchmark")
                category = result.get("category")
                requirement = result.get("requirement")
                requirement_id = result.get("requirement_id")
                benchmark_entry = BenchmarkEntry(
                    benchmark=benchmark,
                    category=category,
                    requirement=requirement,
                    requirement_id=requirement_id,
                )
                results[result.get("name")].benchmarks[benchmark] = benchmark_entry
        return results

