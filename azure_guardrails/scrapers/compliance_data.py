from typing import Dict


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


class ComplianceResult:
    def __init__(self, result_entry):
        self.result_entry_json = result_entry
        self.policy_id = result_entry.get("policy_id")
        self.service_name = result_entry.get("service_name")
        self.effects = result_entry.get("effects")
        self.description = result_entry.get("description")
        self.name = result_entry.get("name")
        self.benchmarks = self._benchmarks()

    def __repr__(self) -> dict:
        benchmark_response = {}
        for benchmark in self.benchmarks:
            benchmark_response[benchmark.benchmark] = benchmark.json()
        result = dict(
            policy_id=self.policy_id,
            effects=self.effects,
            description=self.description,
            name=self.name,
            benchmarks=benchmark_response,
        )
        return result

    def json(self) -> dict:
        return self.__repr__()

    def _benchmarks(self) -> [BenchmarkEntry]:
        result = []
        benchmark = self.result_entry_json.get("benchmark")
        category = self.result_entry_json.get("category")
        requirement = self.result_entry_json.get("requirement")
        requirement_id = self.result_entry_json.get("requirement_id")
        benchmark_entry = BenchmarkEntry(benchmark=benchmark, category=category, requirement=requirement, requirement_id=requirement_id)
        result.append(benchmark_entry)
        return result


class ComplianceResults:
    def __init__(self, results_list: list):
        print()
        self.results_list_json = results_list
        self.results = self._results()

    def __repr__(self) -> dict:
        response = {}
        for result_key, result_value in self.results.items():
            response[result_key] = result_value.json()
        return response

    def json(self) -> dict:
        return self.__repr__()

    def _results(self) -> {ComplianceResult}:
        results = {}
        for result in self.results_list_json:
            if result.get("name") not in results.keys():
                compliance_result = ComplianceResult(result_entry=result)
                results[result.get("name")] = compliance_result
            else:
                benchmark = result.get("benchmark")
                category = result.get("category")
                requirement = result.get("requirement")
                requirement_id = result.get("requirement_id")
                benchmark_entry = BenchmarkEntry(benchmark=benchmark, category=category, requirement=requirement,
                                                 requirement_id=requirement_id)
                results[result.get("name")].benchmarks.append(benchmark_entry)
        return results

